// Toggle the external monitor on macOS (disable <-> enable).
//
// Uses the private SkyLight API `SLSConfigureDisplayEnabled` (resolved at
// runtime via dlsym, so no private SDK symbols are needed at link time).
// Disabled displays may vanish from CoreGraphics' display lists, so the ID of
// the disabled display is remembered in a state file to be able to re-enable it.
//
// Usage: toggle-external-monitor [toggle|enable|disable|status]

#include <CoreGraphics/CoreGraphics.h>
#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

typedef CGError (*ConfigureDisplayEnabledFn)(CGDisplayConfigRef, CGDirectDisplayID, bool);

#define MAX_DISPLAYS 32

static ConfigureDisplayEnabledFn load_configure_fn(void) {
  void *handle = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_LAZY);
  void *fn = handle ? dlsym(handle, "SLSConfigureDisplayEnabled") : NULL;
  if (!fn) {
    // older macOS versions export it from CoreGraphics
    fn = dlsym(RTLD_DEFAULT, "CGSConfigureDisplayEnabled");
  }
  if (!fn) {
    fprintf(stderr, "error: could not resolve SLSConfigureDisplayEnabled\n");
    exit(1);
  }
  return (ConfigureDisplayEnabledFn)fn;
}

static void state_path(char *buf, size_t len) {
  const char *cache = getenv("XDG_CACHE_HOME");
  const char *home = getenv("HOME");
  if (cache && *cache) {
    snprintf(buf, len, "%s/toggle-external-monitor", cache);
  } else {
    snprintf(buf, len, "%s/.cache/toggle-external-monitor", home ? home : "/tmp");
  }
}

static bool read_state(CGDirectDisplayID *id) {
  char path[1024];
  state_path(path, sizeof(path));
  FILE *f = fopen(path, "r");
  if (!f) return false;
  unsigned int value;
  bool ok = fscanf(f, "%u", &value) == 1;
  fclose(f);
  if (ok) *id = value;
  return ok;
}

static void write_state(CGDirectDisplayID id) {
  char path[1024];
  state_path(path, sizeof(path));
  char *slash = strrchr(path, '/');
  *slash = '\0';
  mkdir(path, S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);  // ~/.cache may not exist yet
  *slash = '/';
  FILE *f = fopen(path, "w");
  if (!f) {
    fprintf(stderr, "warning: cannot write %s: %s\n", path, strerror(errno));
    return;
  }
  fprintf(f, "%u\n", id);
  fclose(f);
}

static void clear_state(void) {
  char path[1024];
  state_path(path, sizeof(path));
  unlink(path);
}

static bool set_enabled(CGDirectDisplayID id, bool enabled) {
  ConfigureDisplayEnabledFn configure = load_configure_fn();
  CGDisplayConfigRef config;
  if (CGBeginDisplayConfiguration(&config) != kCGErrorSuccess) return false;
  if (configure(config, id, enabled) != kCGErrorSuccess) {
    CGCancelDisplayConfiguration(config);
    return false;
  }
  return CGCompleteDisplayConfiguration(config, kCGConfigureForSession) == kCGErrorSuccess;
}

// Returns the first active external display, 0 if none. `active_count` is set
// to the total number of active displays.
static CGDirectDisplayID find_active_external(uint32_t *active_count) {
  CGDirectDisplayID displays[MAX_DISPLAYS];
  uint32_t count = 0;
  CGGetActiveDisplayList(MAX_DISPLAYS, displays, &count);
  *active_count = count;
  for (uint32_t i = 0; i < count; i++) {
    if (!CGDisplayIsBuiltin(displays[i])) return displays[i];
  }
  return 0;
}

static int do_enable(void) {
  CGDirectDisplayID id;
  if (!read_state(&id)) {
    fprintf(stderr, "no disabled external monitor recorded\n");
    return 1;
  }
  clear_state();
  if (!set_enabled(id, true)) {
    fprintf(stderr, "error: failed to enable display %u\n", id);
    return 1;
  }
  printf("enabled display %u\n", id);
  return 0;
}

static int do_disable(void) {
  uint32_t active = 0;
  CGDirectDisplayID id = find_active_external(&active);
  if (!id) {
    fprintf(stderr, "no active external monitor found\n");
    return 1;
  }
  if (active < 2) {
    // e.g. clamshell mode: disabling would leave us without any screen
    fprintf(stderr, "refusing to disable the only active display\n");
    return 1;
  }
  if (!set_enabled(id, false)) {
    fprintf(stderr, "error: failed to disable display %u\n", id);
    return 1;
  }
  write_state(id);
  printf("disabled display %u\n", id);
  return 0;
}

int main(int argc, char **argv) {
  const char *cmd = argc > 1 ? argv[1] : "toggle";
  CGDirectDisplayID id;

  if (strcmp(cmd, "enable") == 0) return do_enable();
  if (strcmp(cmd, "disable") == 0) return do_disable();
  if (strcmp(cmd, "status") == 0) {
    uint32_t active = 0;
    CGDirectDisplayID ext = find_active_external(&active);
    if (ext) printf("enabled (display %u)\n", ext);
    else if (read_state(&id)) printf("disabled (display %u)\n", id);
    else printf("no external monitor\n");
    return 0;
  }
  if (strcmp(cmd, "toggle") == 0) {
    if (read_state(&id)) return do_enable();
    return do_disable();
  }
  fprintf(stderr, "usage: %s [toggle|enable|disable|status]\n", argv[0]);
  return 2;
}
