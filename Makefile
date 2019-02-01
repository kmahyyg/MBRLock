MBR_VM_IMG=winXP_pure.img
FLOPPY_IMG=myfloppy.vfd
PRODUCT_VM_IMG=winXP_mbrlocked.img

all: clean asmc vfdc pattable writedata

pattable:
	echo "Extracting partition table from original VM image..."
	dd if=$(MBR_VM_IMG) of=./mbr_ori bs=512 skip=0 count=1
	dd if=./mbr_ori of=./pattable bs=1 skip=440
	
asmc:
	echo "Compiling assembly code using NASM..."
	nasm crypt-mbr.s
	nasm mbr-place.s
	nasm decrypt-mbr.s
	nasm teststr.s
	
vfdc:
	echo "Creating empty floppy disk image..."
	echo "If you want to modify it manually and fail to mount, you must use offset flag and ensure that loopback module is enabled.\n"
	fallocate -l 1474560 $(FLOPPY_IMG)
	
clean:
	echo "Cleaning up..."
	rm mbr-place crypt-mbr teststr decrypt-mbr pattable mbr_ori prod.mbr $(FLOPPY_IMG) $(PRODUCT_VM_IMG)
	
writedata:
	echo "Writing data to product image..."
	# Build initial disk image for next step
	cp $(MBR_VM_IMG) $(PRODUCT_VM_IMG)
	# Build MBR Protector Wizard: Choice 
	cat mbr-place pattable > prod.mbr
	dd if=prod.mbr of=$(PRODUCT_VM_IMG) bs=512 count=1 conv=notrunc
	# Write TESTSTR to FDD 1,0,0,4
	dd if=teststr of=$(FLOPPY_IMG) bs=512 skip=3 count=1 conv=notrunc
	# Write Encryptor to FDD 1,0,0,1
	dd if=crypt-mbr of=$(FLOPPY_IMG) bs=512 skip=0 count=1 conv=notrunc
	# Write Decryptor to FDD 1,0,0,2
	dd if=decrypt-mbr of=$(FLOPPY_IMG) bs=512 skip=1 count=1 conv=notrunc
	# Write OriginalMBR for preparation, HDD 1,0,0,3
	dd if=mbr_ori of=$(PRODUCT_VM_IMG) bs=512 skip=2 count=1 conv=notrunc
	sync; sleep 5
	
