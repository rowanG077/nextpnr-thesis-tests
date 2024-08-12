NEXTPNR_SEED=
NEXTPNR=../nextpnr/build/nextpnr-ecp5

DEV_MAC_ADDRESS=ae:12:34:56:78:6E

.PHONY: .FORCE
.FORCE:

.DEFAULT_GOAL := all

ifeq ($(NEXTPNR_SEED),)
	nextpnr_extra_flags+=--randomize-seed
else
	nextpnr_extra_flags+=--seed ${NEXTPNR_SEED}
endif

ifeq ($(NEXTPNR_TIMING_ALLOW_FAIL),1)
	nextpnr_extra_flags+=--timing-allow-fail
endif


# Force nextpnr to rerun. Can be very useful because it's a probalistic
# process without a seed
ifneq ($(FORCE_PNR),0)
	extra_nextpnr_dep=.FORCE
else
	extra_nextpnr_dep=
endif

.PHONY: clean
clean:
	rm -rf build

build/ff_sync.json: tests/ff_sync.v
	mkdir -p build
	yosys \
		-p "synth_ecp5 -top ff_sync -json build/ff_sync.json;" \
		tests/ff_sync.v

build/ff_sync.cfg: build/ff_sync.json tests/ff_sync.sdc
	${NEXTPNR} --json build/ff_sync.json \
		--textcfg build/ff_sync.cfg --25k \
		--sdc tests/ff_sync.sdc \
		--speed 6 \
		--package CABGA256 \
		--lpf-allow-unconstrained \
		${nextpnr_extra_flags}


.PHONY: all
all: build/ff_sync.cfg
