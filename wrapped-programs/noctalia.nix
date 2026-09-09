{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        package = pkgs.noctalia-shell.overrideAttrs {
          name = "jdy4knoctalia";
        };
        env = {
          "NOCTALIA_CACHE_DIR" = "/home/jdy4k/.cache/jdy4k-noctalia/";
        };
        colors = {
          mError = "#fb4934";
          mHover = "#83a598";
          mOnError = "#282828";
          mOnHover = "#282828";
          mOnPrimary = "#282828";
          mOnSecondary = "#282828";
          mOnSurface = "#fbf1c7";
          mOnSurfaceVariant = "#ebdbb2";
          mOnTertiary = "#282828";
          mOutline = "#57514e";
          mPrimary = "#b8bb26";
          mSecondary = "#fbf1c7";
          mShadow = "#282828";
          mSurface = "#282828";
          mSurfaceVariant = "#3c3836";
          mTertiary = "#83a598";
        };
        settings = {
          appLauncher = {
            customLaunchPrefix = "";
            customLaunchPrefixEnabled = false;
            enableClipPreview = true;
            enableClipboardHistory = false;
            iconMode = "tabler";
            pinnedExecs = [];
            position = "center";
            showCategories = true;
            sortByMostUsed = true;
            terminalCommand = "kitty -e";
            useApp2Unit = false;
            viewMode = "list";
          };
          audio = {
            cavaFrameRate = 30;
            externalMixer = "pwvucontrol";
            mprisBlacklist = [];
            preferredPlayer = "";
            visualizerType = "linear";
            volumeOverdrive = false;
            volumeStep = 5;
          };
          bar = {
            capsuleOpacity = 1;
            density = "compact";  # mini=21px, compact=25px, default=31px
            widgetSpacing = "2";
            contentPadding = "8";
            exclusive = true;
            floating = false;
            marginHorizontal = 0.25;
            marginVertical = 0.25;
            monitors = [ "DP-2" "eDP-1" ];
            outerCorners = false;
            position = "top";
            showCapsule = false;
            showOutline = false;
            transparent = false;
            widgets = {
              center = [];
              left = [
                {
                  colorizeDistroLogo = true;
                  colorizeSystemIcon = "none";
                  customIconPath = "";
                  enableColorization = true;
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                {
                  characterCount = 2;
                  colorizeIcons = false;
                  enableScrollWheel = true;
                  followFocusedScreen = false;
                  hideUnoccupied = true;
                  id = "Workspace";
                  labelMode = "none";
                  showApplications = false;
                  showLabelsOnlyWhenOccupied = true;
                  occupiedWorkspaceColor = "none";
                  emptyWorkspaceColor = "none";
                  pillSize = "0.40";
                }
              ];
              right = [
                {
                  hideWhenZero = false;
                  id = "NotificationHistory";
                  showUnreadBadge = true;
                }
                {
                  displayMode = "alwaysHide";
                  id = "Volume";
                }
                {
                  displayMode = "alwaysHide";
                  id = "Microphone";
                }
                {
                  deviceNativePath = "";
                  displayMode = "graphic";
                  hideIfNotDetected = true;
                  id = "Battery";
                  showNoctaliaPerformance = false;
                  showPowerProfiles = false;
                  warningThreshold = 20;
                }
                {
                  customFont = "";
                  formatHorizontal = "HH:mm ddd    MMM dd";
                  formatVertical = "HH mm - dd MM";
                  id = "Clock";
                  useCustomFont = false;
                  usePrimaryColor = true;
                }
                {
                  blacklist = [];
                  colorizeIcons = false;
                  drawerEnabled = true;
                  hidePassive = false;
                  id = "Tray";
                  pinned = [];
                }
              ];
            };
          };
          brightness = {
            brightnessStep = 5;
            enableDdcSupport = false;
            enforceMinimum = true;
          };
          calendar = {
            cards = [
              {
                enabled = true;
                id = "calendar-header-card";
              }
              {
                enabled = true;
                id = "calendar-month-card";
              }
              {
                enabled = true;
                id = "timer-card";
              }
              {
                enabled = true;
                id = "weather-card";
              }
            ];
          };
          # colorSchemes = {
          #   darkMode = true;
          #   generateTemplatesForPredefined = true;
          #   manualSunrise = "06:30";
          #   manualSunset = "18:30";
          #   matugenSchemeType = "scheme-fruit-salad";
          #   predefinedScheme = "Gruvbox";
          #   schedulingMode = "off";
          #   useWallpaperColors = false;
          # };
          controlCenter = {
            cards = [
              {
                enabled = true;
                id = "profile-card";
              }
              {
                enabled = true;
                id = "shortcuts-card";
              }
              {
                enabled = true;
                id = "audio-card";
              }
              {
                enabled = true;
                id = "brightness-card";
              }
              {
                enabled = true;
                id = "weather-card";
              }
              {
                enabled = true;
                id = "media-sysmon-card";
              }
            ];
            position = "close_to_bar_button";
            shortcuts = {
              left = [
                {id = "WiFi";}
                {id = "Bluetooth";}
                {id = "ScreenRecorder";}
              ];
              right = [
                {id = "Notifications";}
                {id = "PowerProfile";}
              ];
            };
          };
          desktopWidgets = {
            enabled = false;
            gridSnap = false;
            monitorWidgets = [
              {
                name = "HDMI-A-1";
                widgets = [
                  {
                    hideMode = "visible";
                    id = "MediaPlayer";
                    showBackground = true;
                    showButtons = true;
                    visualizerType = "linear";
                    x = 100;
                    y = 200;
                  }
                ];
              }
            ];
          };
          dock = {
            animationSpeed = 2;
            backgroundOpacity = 1;
            colorizeIcons = false;
            deadOpacity = 0.6;
            displayMode = "auto_hide";
            enabled = false;
            floatingRatio = 1;
            inactiveIndicators = false;
            monitors = [ "eDP-1" ];
            onlySameOutput = true;
            pinnedApps = [];
            pinnedStatic = false;
            size = 1;
          };
          general = {
            telemetryEnabled = false;
            # avatarImage = "/$HOME/nixconf/avatar.jpg";
            allowPanelsOnScreenWithoutBar = true;
            animationDisabled = false;
            animationSpeed = 1;
            boxRadiusRatio = 1;
            compactLockScreen = false;
            dimmerOpacity = 0.15;
            enableShadows = true;
            forceBlackScreenCorners = false;
            iRadiusRatio = 1;
            language = "";
            lockOnSuspend = true;
            radiusRatio = 1;
            scaleRatio = 1;
            screenRadiusRatio = 1;
            shadowDirection = "bottom_right";
            shadowOffsetX = 2;
            shadowOffsetY = 3;
            showChangelogOnStartup = false;
            showHibernateOnLockScreen = false;
            showScreenCorners = false;
            showSessionButtonsOnLockScreen = true;
          };
          hooks = {
            darkModeChange = "";
            enabled = false;
            performanceModeDisabled = "";
            performanceModeEnabled = "";
            screenLock = "";
            screenUnlock = "";
            wallpaperChange = "";
          };
          location = {
            analogClockInCalendar = false;
            firstDayOfWeek = -1;
            showCalendarEvents = true;
            showCalendarWeather = true;
            showWeekNumberInCalendar = false;
            use12hourFormat = false;
            useFahrenheit = false;
            weatherEnabled = true;
            weatherShowEffects = true;
          };
          region = {
            enableWeather = false;
          };
          network = {wifiEnabled = true;};
          nightLight = {
            autoSchedule = true;
            dayTemp = "6500";
            enabled = false;
            forced = false;
            manualSunrise = "06:30";
            manualSunset = "18:30";
            nightTemp = "4000";
          };
          notifications = {
            backgroundOpacity = 1;
            criticalUrgencyDuration = 15;
            enableKeyboardLayoutToast = true;
            enabled = true;
            location = "top_right";
            lowUrgencyDuration = 8;
            monitors = [];
            normalUrgencyDuration = 8;
            overlayLayer = true;
            respectExpireTimeout = false;
            sounds = {
              criticalSoundFile = "";
              enabled = false;
              excludedApps = "discord,firefox,chrome,chromium,edge";
              lowSoundFile = "";
              normalSoundFile = "";
              separateSounds = false;
              volume = 0.5;
            };
          };
          osd = {
            autoHideMs = 3000;
            backgroundOpacity = 1;
            enabled = true;
            enabledTypes = [
              0
              1
              2
              4
            ];
            location = "bottom";
            monitors = [];
            overlayLayer = true;
          };
          screenRecorder = {
            audioCodec = "opus";
            audioSource = "default_output";
            colorRange = "limited";
            directory = "/home/yurii/Videos";
            frameRate = 60;
            quality = "very_high";
            showCursor = true;
            videoCodec = "h264";
            videoSource = "portal";
          };
          sessionMenu = {
            countdownDuration = 10000;
            enableCountdown = true;
            largeButtonsStyle = false;
            position = "center";
            powerOptions = [
              {
                action = "lock";
                command = "";
                countdownEnabled = true;
                enabled = true;
              }
              {
                action = "suspend";
                command = "";
                countdownEnabled = true;
                enabled = true;
              }
              {
                action = "hibernate";
                command = "";
                countdownEnabled = true;
                enabled = true;
              }
              {
                action = "reboot";
                command = "";
                countdownEnabled = true;
                enabled = true;
              }
              {
                action = "logout";
                command = "";
                countdownEnabled = true;
                enabled = true;
              }
              {
                action = "shutdown";
                command = "";
                countdownEnabled = true;
                enabled = true;
              }
            ];
            showHeader = true;
          };
          settingsVersion = 32;
          systemMonitor = {
            cpuCriticalThreshold = 90;
            cpuPollingInterval = 3000;
            cpuWarningThreshold = 80;
            criticalColor = "";
            diskCriticalThreshold = 90;
            diskPollingInterval = 3000;
            diskWarningThreshold = 80;
            enableDgpuMonitoring = false;
            gpuCriticalThreshold = 90;
            gpuPollingInterval = 3000;
            gpuWarningThreshold = 80;
            memCriticalThreshold = 90;
            memPollingInterval = 3000;
            memWarningThreshold = 80;
            networkPollingInterval = 3000;
            tempCriticalThreshold = 90;
            tempPollingInterval = 3000;
            tempWarningThreshold = 80;
            useCustomColors = false;
            warningColor = "";
          };
          templates = {
            alacritty = false;
            cava = false;
            code = false;
            discord = false;
            emacs = false;
            enableUserTemplates = false;
            foot = false;
            fuzzel = false;
            ghostty = false;
            gtk = false;
            helix = false;
            hyprland = false;
            kcolorscheme = false;
            kitty = false;
            mango = false;
            niri = false;
            pywalfox = false;
            qt = false;
            spicetify = false;
            telegram = false;
            vicinae = false;
            walker = false;
            wezterm = false;
            yazi = false;
            zed = false;
          };
          ui = {
            bluetoothDetailsViewMode = "grid";
            bluetoothHideUnnamedDevices = false;
            fontDefault = "Sans Serif";
            fontDefaultScale = 1.2;
            fontFixed = "monospace";
            fontFixedScale = 1.2;
            panelBackgroundOpacity = 1;
            panelsAttachedToBar = true;
            settingsPanelMode = "attached";
            tooltipsEnabled = true;
            wifiDetailsViewMode = "grid";
          };
          wallpaper = {
            # bye bye
            enabled = false;
          };
        };
      };
    };
  };
}
