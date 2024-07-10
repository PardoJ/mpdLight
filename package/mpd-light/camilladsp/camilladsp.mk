################################################################################
#
# camilladsp
#
#################################################################################

CAMILLADSP_VERSION = v2.0.3
CAMILLADSP_SITE = https://github.com/HEnquist/camilladsp.git
CAMILLADSP_SITE_METHOD = git
CAMILLADSP_LICENSE = GPL-3.0+


CAMILLADSP_DEPENDENCIES = host-rustc alsa-lib

CAMILLADSP_CARGO_ENV = CARGO_HOME=$(HOST_DIR)/share/cargo PKG_CONFIG=$(HOST_DIR)/bin/pkg-config CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=$(HOST_DIR)/bin/aarch64-buildroot-linux-gnu-cc

CAMILLADSP_CARGO_MODE = $(if $(BR2_ENABLE_DEBUG),debug,release)
CAMILLADSP_BIN_DIR = target/$(RUSTC_TARGET_NAME)/$(CAMILLADSP_CARGO_MODE)

CAMILLADSP_CARGO_OPTS = \
    $(if $(BR2_ENABLE_DEBUG),,--release) \
    --target=$(RUSTC_TARGET_NAME) \
    --manifest-path=$(@D)/Cargo.toml \
    --no-default-features

define CAMILLADSP_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(CAMILLADSP_CARGO_ENV) \
            cargo build $(CAMILLADSP_CARGO_OPTS)
endef

define CAMILLADSP_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/$(CAMILLADSP_BIN_DIR)/camilladsp \
            $(TARGET_DIR)/usr/bin/camilladsp
endef

CAMILLADSP_CARGO_OPTS += --features "websocket"
ifeq ($(BR2_CAMILLADSP_WEBSOCKET),y)
CAMILLADSP_CARGO_OPTS += --features "websocket"
endif

ifeq ($(BR2_CAMILLADSP_DEBUG),y)
CAMILLADSP_CARGO_OPTS += --features "debug"
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
CAMILLADSP_DEPENDENCIES += pulseaudio
CAMILLADSP_CARGO_OPTS += --features "pulse-backend"
endif

ifeq ($(BR2_PACKAGE_JACK2),y)
CAMILLADSP_DEPENDENCIES += jack2
CAMILLADSP_CARGO_OPTS += --features "jack-backend"
endif

ifeq ($(BR2_PACKAGE_BLUEZ_ALSA),y)
CAMILLADSP_CARGO_OPTS += --features "bluez-backend"
endif

$(eval $(generic-package))

#define CAMILLADSP_BUILD_CMDS
#     echo 'coucou'
#endef

#     cd $(MY_RUST_APP_SRCDIR) && \
#         PATH=$(HOST_DIR)/bin:$(PATH) $(PKG_CARGO_ENV) cargo fetch

#$(eval $(cargo-package))
