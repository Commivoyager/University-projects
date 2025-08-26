#include <SFML/Graphics.hpp>
#include <iostream>
#include <string>
#define SIZE 950
#define IMAGES 20000
using namespace std;

typedef struct Timg
{
	int x = 0, y = 0;
	int clust = 0;
};
typedef struct Tcol
{
	int r = 0, b = 0, g = 0;
};

void inp(int& imnum)
{
	cout << "Images: ";
	do
	{
		cin >> imnum;
	} while (imnum < 1000 || imnum > 100000);
	//imnum = IMAGES;
}
void imrand(Timg* imarr, int imnum, int fsize)
{
	for (int i = 0; i < imnum; i++)
	{
		imarr[i].x = rand() % fsize;
		imarr[i].y = rand() % fsize;
	}
}
double distcalc(int x1, int y1, int x2, int y2)
{
	int diffx = x1 - x2;
	int diffy = y1 - y2;
	return (sqrt(diffx * diffx + diffy * diffy));
}
void addtoarr(int* &arr, int& size, int& last, int value)
{
	int tempsize;
	int* temparr;
	if (++last >= size)
	{
		tempsize = size;
		size *= 1.5;
		temparr = new int[size]{};
		for (int i = 0; i < tempsize; i++)
		{
			temparr[i] = arr[i];
		}
		delete[]arr;
		arr = temparr;
	}
	arr[last] = value;
}
int find2ndcore(Timg* imarr, int imnum, int corenum)
{
	int max = 0;
	int indmax = 0;
	int temp;
	int x = imarr[corenum].x, y = imarr[corenum].y;
	for (int i = 0; i < imnum; i++)
	{
		temp = distcalc(x, y, imarr[i].x, imarr[i].y);
		if (max < temp)
		{
			max = temp;
			indmax = i;
		}
	}	
	return indmax;
}
void newcore(Timg* imarr, int imnum, int* arr, int last, int &maxdist, int &maxind)
{
	int temp;
	int tempind;
	for (int i = 0; i < imnum; i++)
	{
		tempind = arr[imarr[i].clust];
		temp = distcalc(imarr[i].x, imarr[i].y, imarr[tempind].x, imarr[tempind].y);
		if (temp > maxdist)
		{
			maxdist = temp;
			maxind = i;
		}
	}
}
void clustbymin(Timg* imarr, int imnum, int fsize, int*& arr, int& last)
{
	for (int i = 0; i < imnum; i++)
	{
		int max = 0;
		int indmax = 0;
		int x = imarr[i].x, y = imarr[i].y;
		double mindist = fsize << 1, temp;
		int minclust = imnum;
		// <= - верно
		for (int i = 0; i <= last; i++)
		{
			temp = distcalc(x, y, imarr[arr[i]].x, imarr[arr[i]].y);
			if (temp < mindist)
			{
				mindist = temp;
				minclust = i;
			}
		}
		imarr[i].clust = minclust; //Нужно ли +1 ???

	}
}
bool greaterthanmean(Timg* imarr, int imnum, int* &arr, int& size, int& last, int maxdist, int maxind)
{
	double sum = 0;
	int count = 0;
	for (int i = 0; i <  last; i++)
	{
		int x1 = imarr[arr[i]].x;
		int y1 = imarr[arr[i]].y;
		for (int j = i + 1; j <= last; j++)
		{
			int x2 = imarr[arr[j]].x;
			int y2 = imarr[arr[j]].y;
			sum += distcalc(x1, y1, x2, y2);
			count++;
		}
	}
	sum = sum / count / 2;
	if (maxdist > sum)
	{
		addtoarr(arr, size, last, maxind);
		return true;
	}
	return false;
}
void addcol(Tcol* arr, int& size, int& last)
{
	int tempsize;
	Tcol* temparr;
	if (++last >= size)
	{
		tempsize = size;
		size *= 1.5;
		temparr = new Tcol[size] {};
		for (int i = 0; i < tempsize; i++)
		{
			temparr[i] = arr[i];
		}
		delete[]arr;
		arr = temparr;
	}
	arr[last].r = rand() % 255;
	arr[last].g = rand() % 255;
	arr[last].b = rand() % 255;
}
void drawing(int scrsize, int elsize, int imnum, int stepcol, Timg* imarr, int lastcl, int* clarr, string count, Tcol* colarr)
{
	// Отрисовка
	sf::RenderWindow window1(sf::VideoMode(scrsize + 30, scrsize + 30), count + " iteration");
	sf::CircleShape circle(elsize);
	window1.setPosition(sf::Vector2i(0, 0));
	sf::Event event;
	do
	{
		while (window1.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window1.close();
		}
		window1.clear();

		circle.setRadius(elsize);
		int color;
		for (int i = 0; i < imnum; i++)
		{
			color = stepcol * imarr[i].clust;
			int colind = imarr[i].clust;
			circle.setFillColor(sf::Color(colarr[colind].r, colarr[colind].g, colarr[colind].b));
			//circle.setFillColor(sf::Color(imarr[i].clust % 2 * 255, color, (color % 3) * 255));
			//circle.setFillColor(sf::Color(i%2*color,color,(i%2+1)*color));
			circle.setPosition(imarr[i].x * (elsize), imarr[i].y * (elsize));
			window1.draw(circle);
		}
		circle.setFillColor(sf::Color(255, 255, 0));
		circle.setRadius(4 + elsize);
		circle.setOutlineThickness(3);
		circle.setOutlineColor(sf::Color(0, 0, 0));
		for (int i = 0; i <= lastcl; i++)
		{
			circle.setPosition(imarr[clarr[i]].x * (elsize), imarr[clarr[i]].y * (elsize));
			window1.draw(circle);
		}
		circle.setOutlineThickness(0);
		window1.display();
	} while (window1.isOpen() && event.type != sf::Event::MouseButtonPressed);
}
bool minstdevcore(Timg* imarr, int imnum, int* clarr, int last)
{
	bool res = true;
	Timg* newcore = new Timg[last+1];
	for (int i = 0; i < imnum; i++)
	{
		int clust = imarr[i].clust;
		newcore[clust].x += imarr[i].x;
		newcore[clust].y += imarr[i].y;
		newcore[clust].clust++;
	}
	int x, y;
	for (int i = 0; i <= last; i++)
	{
		x = newcore[i].x / newcore[i].clust;
		y = newcore[i].y / newcore[i].clust;
		if (imarr[clarr[i]].x != x || imarr[clarr[i]].y != y)
		{
			imarr[clarr[i]].x = x;
			imarr[clarr[i]].y = y;
			res = false;
		}
	}
	delete[]newcore;
	return res;
}

int main()
{
	Timg* imarr;
	int clarrsize = 20;
	int lastcl = 0;
	int* clarr = new int[clarrsize];
	int imnum;
	int fsize;
	inp(imnum);
	srand(time(NULL));
	fsize = sqrt(imnum * 10) + 1;
	imarr = new Timg[imnum];
	imrand(imarr, imnum, fsize);

	//1
	clarr[lastcl] = rand() % imnum;
	addtoarr(clarr, clarrsize, lastcl, find2ndcore(imarr, imnum, clarr[lastcl]));
	

	int const stepcol = 255 / (lastcl + 1);
	int elsize = SIZE / fsize;
	int	scrsize = elsize * fsize;

	int colarrsize = 20;
	int lastcol = -1;
	Tcol* colarr = new Tcol[colarrsize];
	addcol(colarr, colarrsize, lastcol);


	int count = 0;
	int maxdist, maxind;
	do
	{
		count++;
		clustbymin(imarr, imnum, fsize, clarr, lastcl);
		addcol(colarr, colarrsize, lastcol);
		maxdist = 0;
		maxind = 0;
		newcore(imarr, imnum, clarr, lastcl, maxdist, maxind);
		drawing(scrsize, elsize, imnum, stepcol, imarr, lastcl, clarr, to_string(count), colarr);
	} while (greaterthanmean(imarr, imnum, clarr, clarrsize, lastcl, maxdist, maxind));
	drawing(scrsize, elsize, imnum, stepcol, imarr, lastcl, clarr, to_string(count)+" is last", colarr);

	cout << "Cores: " << lastcl + 1 << endl;
	cout << "Iterations: " << count << endl;

	// k-means algorithm
	count = 0;
	while (!minstdevcore(imarr, imnum, clarr, lastcl))
	{
		clustbymin(imarr, imnum, fsize, clarr, lastcl);
		count++;
	}
	drawing(scrsize, elsize, imnum, stepcol, imarr, lastcl, clarr, "After k-means algorithm " + to_string(count), colarr);
	cout << "Number of k-means algorithms iterations: " << count;
	delete[]clarr;
	clarr = NULL;
	delete[]imarr;
	imarr = NULL;
	delete[]colarr;
	return 0;
}