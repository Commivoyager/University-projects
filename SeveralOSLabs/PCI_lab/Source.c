/*
Cканирование PCI-шины компьютера для определения подключённых устройств.
Перебор 256 шин, 32 устройств на каждой шине и 8 функций на устройстве.
Выводимые данные для каждого устройства:
	Шина, устройство, функция
	Vendor ID и Device ID
	Название производителя и устройства
	Номер прерывания
	I/O порты (BARs)
	Класс устройства (Class Code)
*/

#include<stdio.h>
#include <sys/io.h>
#include <stdint.h>
#include"../devices.h"
#include"../vendors.h"
//#include"../pci.h"
int main(void)
{
	const uint32_t init_addr = 0x80000000;
	uint32_t addr, dvinfo, temp = 0, shft = 0, zernum;
	unsigned short dev = 0, vend = 0;
	int count = 0, devcount = 0;
	FILE *f;
	f = fopen("res.txt", "w");
	if(iopl(3))
	{
		printf("I/O Privilege level change error!\nTry running under ROOT user\n");
	}
	else
	{
		for(uint32_t bus = 0; bus < 256; bus++)
		{
			for(uint32_t device = 0; device < 32; device++)
			{
				for(uint32_t func = 0; func < 8; func++)
				{
					addr = init_addr | (bus << 16) | (device << 11) | (func << 8);
					outl((unsigned int)addr,0xCF8);
					dvinfo = inl(0xCFC);
					vend = (unsigned short)dvinfo;
					dev = (unsigned short)(dvinfo>>16);
					if(dev != 0xFFFF)
					{
						fprintf(f, "%d:\n\t%-5d", devcount, bus);
						fprintf(f,"%-5d", device);
						fprintf(f,"%-5d", func);
						fprintf(f, "%#-10x", vend);
						fprintf(f,"%#-10x", dev);
						devcount++;
						for(int i = 0; i < PCI_VENTABLE_LEN; i++)
						{
							if(vend == PciVenTable[i].VendorId)
							{
								fprintf(f, "%-30s", PciVenTable[i].VendorName);
								i = PCI_VENTABLE_LEN;
							}
						}
						for(int j = 0; j < PCI_DEVTABLE_LEN; j++)
						{
							if(vend == PciDevTable[j].VendorId)
							{
								if(dev == PciDevTable[j].DeviceId)
								{
									fprintf(f,"%s\n", PciDevTable[j].DeviceName); 
									j = PCI_DEVTABLE_LEN;
								}
							}
						}
						temp = addr | (0x0C<<2);
						outl((unsigned int)temp, 0xCF8);
						dvinfo = (uint32_t)inl(0xCFC);
						temp = (dvinfo>>16) & 1;
						if((0 == temp))
						{
							temp = addr | (0x3C<<2);
							outl(temp, 0xCF8);
							dvinfo = inl(0xCFC);
							temp = (dvinfo>>8) & 0xFF;
							fprintf(f,"\n\tInterrupt Pin:\t%d\t",temp);
							switch(temp)
							{
							case 0:
								fprintf(f,"Not used\n");
								break;
							case 1:
								fprintf(f,"INTА# line is used\n");
								break;
							case 2:
								fprintf(f,"INTB# line is used\n");
								break;
							case 3:
								fprintf(f,"INTC# line is used\n");
								break;
							case 4:
								fprintf(f,"INTD# line is used\n");
								break;
							default:
								fprintf(f,"Reserved value\n");
							};
							
							shft = 0x10;
							for(int i = 0; i<6; i++);
							{
								count = 0;
								temp = addr | (shft<<2);
								outl(temp, 0xCF8);
								dvinfo = (uint32_t)inl(0xCFC);	
								shft = shft + 4;
								fprintf(f, "\n\tI/O ports BARs:\n");
								if(0!=(1&dvinfo))
								{
									fprintf(f,"\tZero bit: 1 - port area indication\n");
									fprintf(f,"\tFirst bit: %d - reserved bit\n", (2&dvinfo));
									fprintf(f,"\t31-2 bits: %#x - base address\n", (0x3FFFFFFF&(dvinfo>>2)));
									count++;								
								}
								if(0==count)
								{	
									fprintf(f,"\t-\n");
								}
							}
							
							shft = 0x8;
							temp = addr;
							temp = temp | (shft<<2);
							outl(temp,0xCF8);
							dvinfo = (uint32_t)inl(0xCFC);
							dvinfo = dvinfo>>8;
							fprintf(f,"\n\tClass Code:\n");
							fprintf(f,"\tClass Code Field value: %#x\n", dvinfo);
							fprintf(f,"\tUpper byte: %d - base class of the device\n", (dvinfo>>16)&0xFF);
							fprintf(f,"\tAverage byte: %d - subclass\n", (dvinfo>>8)&0xFF);
							fprintf(f,"\tLowest byte: %d - specific register level programming interface\n\n\n", dvinfo & 0xFF);  
						}
					}
				}
			}
		}
	}
	fclose(f);
	return 0;
}
