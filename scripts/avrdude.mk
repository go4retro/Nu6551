#---------------- Programming Options (avrdude) ----------------

# Programming hardware: alf avr910 avrisp bascom bsd
# dt006 pavr picoweb pony-stk200 sp12 stk200 stk500 stk500v2
#
# Type: avrdude -c ?
# to get a full listing.
#
#AVRDUDE_PROGRAMMER = stk200
ifdef CONFIG_AVRDUDE_PROGRAMMER
  AVRDUDE_PROGRAMMER := -c $(CONFIG_AVRDUDE_PROGRAMMER)
endif

# com1 = serial port. Use lpt1 to connect to parallel port.
#AVRDUDE_PORT = lpt1    # programmer connected to serial device
ifdef CONFIG_AVRDUDE_PORT
  AVRDUDE_PORT := -P $(CONFIG_AVRDUDE_PORT)
endif

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex
# AVRDUDE_WRITE_EEPROM = -U eeprom:w:$(TARGET).eep

# Allow fuse overrides from the config file
ifdef CONFIG_EFUSE
  EFUSE := $(CONFIG_EFUSE)
endif
ifdef CONFIG_HFUSE
  HFUSE := $(CONFIG_HFUSE)
endif
ifdef CONFIG_LFUSE
  LFUSE := $(CONFIG_LFUSE)
endif

# Calculate command line arguments for fuses
AVRDUDE_WRITE_FUSES :=
ifdef EFUSE
  AVRDUDE_WRITE_FUSES += -U efuse:w:$(EFUSE):m
endif
ifdef HFUSE
  AVRDUDE_WRITE_FUSES += -U hfuse:w:$(HFUSE):m
endif
ifdef LFUSE
  AVRDUDE_WRITE_FUSES += -U lfuse:w:$(LFUSE):m
endif


# Uncomment the following if you want avrdude's erase cycle counter.
# Note that this counter needs to be initialized first using -Yn,
# see avrdude manual.
#AVRDUDE_ERASE_COUNTER = -y

# Uncomment the following if you do /not/ wish a verification to be
# performed after programming the device.
#AVRDUDE_NO_VERIFY = -V

# Increase verbosity level.  Please use this when submitting bug
# reports about avrdude. See <http://savannah.nongnu.org/projects/avrdude>
# to submit bug reports.
#AVRDUDE_VERBOSE = -v -v

AVRDUDE_FLAGS = -p $(MCU)
AVRDUDE_FLAGS += $(AVRDUDE_NO_VERIFY)
AVRDUDE_FLAGS += $(AVRDUDE_VERBOSE)
AVRDUDE_FLAGS += $(AVRDUDE_ERASE_COUNTER)
AVRDUDE_FLAGS += $(AVRDUDE_PROGRAMMER) $(AVRDUDE_PORT)

