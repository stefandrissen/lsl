; discard.pic

discard.pic:

	ld hl,(var.free)
	ld de,(var.resource.length)
	or a
	sbc hl,de
	ld (var.free),hl	

	ret