/*
ќбработка файла pci.ids, содержащего список Vendor ID и Device ID PCI-устройств, и генераци€ из него двух заголовочных файлов:
	vendors.h Ц список производителей (Vendor ID + название).
	devices.h Ц список устройств (Vendor ID + Device ID + название).
*/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include<string.h>
void main(void)
{
	FILE* f, * f2, *f3;
	char str[201];
	//const int buf_size = 200;
	char* pstr, name[200];
	pstr = str;
	int last_s;
	unsigned int vend = 0, dev = 0;
	f = fopen("pci.ids", "r");
	f2 = fopen("vendors.h", "a");
	f3 = fopen("devices.h", "a");
	while(NULL != fgets(pstr, 200, f))
	{
		if (((*pstr) != '#')&& ((*pstr) != '\t')&& ((*pstr) != '\n') && ((*pstr) != ' '))
		{
			sscanf(pstr,"%x  ", &vend);
			pstr = pstr + 6;
			
			last_s = strlen(pstr);
			while ('\n' == * (pstr + last_s - 1))
			{
				last_s--;
			}
			*(pstr + last_s) = 0;
			fprintf(f2, "\t{%04x, \"%s\"}\n", vend, pstr);
			pstr = str;
			
		}
		else
		{
			if (((*pstr) == '\t') && (((*(pstr + 1) >= 'a') && (*(pstr + 1) <= 'f')) || ((*(pstr + 1) >= '0') && (*(pstr + 1) <= '9')) || ((*(pstr + 1) >= 'A') && (*(pstr + 1) <= 'F'))))
			{
				//vend;
				sscanf(pstr, "%x  ", &dev);
				pstr = pstr + 6;

				last_s = strlen(pstr);
				while ('\n' == *(pstr + last_s - 1))
				{
					last_s--;
				}
				*(pstr + last_s) = 0;
				fprintf(f3, "\t{%04x, %04x, \"%s\"}\n", vend, dev, pstr);
				pstr = str;

			}
		}
	} 
	fprintf(f2, "};\n\n#define PCI_VENTABLE_LEN (sizeof(PciVenTable)/sizeof(PCI_VENTABLE))");
	fprintf(f3, "};\n\n#define PCI_DEVTABLE_LEN (sizeof(PciDevTable)/sizeof(PCI_DEVTABLE))");
	fclose(f3);
	fclose(f2);
	fclose(f);
}
/*if (strcmp(" 0000  Ethernet Controller X710 Intel(R) FPGA Programmable Acceleration Card N3000 for Networ", pstr) == 0)
			{
				printf("Place");
			}*/

//break;
			//sscanf();
			/*while ('\t' == *pstr)
			{
				pstr = pstr + 1;
			}
			fputs(pstr, f2);
			pstr = str;*/

//
	/*fclose(f);
	f = fopen("pci.ids", "r");
	int count = 0;
	while (NULL != fgets(pstr, 200, f))
	{
		if (((*pstr >= 'a') && (*pstr <= 'z')) || ((*pstr >= 'A') && (*pstr <= 'Z')) || ((*pstr >= '0') && (*pstr <= '9')))
		{
			count++;
		}
	}
	printf("%d", count);*/