#include <SFML/Graphics.hpp>
#include <iostream>
#include <string>
#define SIZE 950
#define CLUSTERS 2
#define IMAGES 1000
using namespace std;

typedef struct Timg
{
	int x = 0, y = 0;
	int clust = 0;
};

void inp(int& clnum, int& imnum)
{
	cout << "Clusters: ";
	do
	{
		cin >> clnum;
	} while (clnum < 2 || clnum > 20);
	cout << "Images: ";
	do
	{
		cin >> imnum;
	} while (imnum < 1000 || imnum > 100000);

	/*clnum = CLUSTERS;
	imnum = IMAGES;*/
}
void imrand(Timg* imarr, int imnum, int fsize)
{
	for (int i = 0; i < imnum; i++)
	{
		imarr[i].x = rand() % fsize;
		imarr[i].y = rand() % fsize;
	}
}
void corerand(Timg* imarr, int clnum, int imnum)
{
	int step = imnum / clnum - 1;
	int ind = step;
	for (int i = imnum, j = 1; i < imnum + clnum; i++, j++, ind += step)
	{
		imarr[i].clust = j;
		bool flag;
		do
		{
			flag = false;
			imarr[i].x = imarr[ind].x;
			imarr[i].y = imarr[ind].y;
			for (int k = imnum; k < i; k++)
			{
				if (imarr[k].x == imarr[i].x && imarr[k].y == imarr[i].y)
				{
					flag = true;
					ind--;
				}
			}
		} while (flag);
	}
}
double distcalc(int x1, int y1, int x2, int y2)
{
	int diffx = x1 - x2;
	int diffy = y1 - y2;
	return (sqrt(diffx * diffx + diffy * diffy));
}
void clustbymin(Timg* imarr, int clnum, int imnum, int fsize)
{
	for (int i = 0; i < imnum; i++)
	{
		int x = imarr[i].x, y = imarr[i].y;
		double mindist = fsize << 1, temp;
		int minclust = imnum;
		for (int i = imnum; i < imnum + clnum; i++)
		{
			temp = distcalc(x, y, imarr[i].x, imarr[i].y);
			if (temp < mindist)
			{
				mindist = temp;
				minclust = i;
			}
		}
		imarr[i].clust = minclust - imnum + 1;
	}
}
bool minstdevcore(Timg* imarr, int clnum, int imnum)
{
	bool res = true;
	Timg* newcore = new Timg[clnum];
	for (int i = 0; i < imnum; i++)
	{
		newcore[imarr[i].clust - 1].x += imarr[i].x;
		newcore[imarr[i].clust - 1].y += imarr[i].y;
		newcore[imarr[i].clust - 1].clust++;
	}
	int x, y;
	for (int i = imnum, j = 0; i < imnum + clnum; i++, j++)
	{
		x = newcore[j].x / newcore[j].clust;
		y = newcore[j].y / newcore[j].clust;
		if (imarr[i].x != x || imarr[i].y != y)
		{
			imarr[i].x = x;
			imarr[i].y = y;
			res = false;
		}
	}
	delete[]newcore;
	return res;
}

int main()
{
	Timg* imarr;
	int clnum, imnum;
	int fsize;
	inp(clnum, imnum);
	srand(time(NULL));
	fsize = sqrt(imnum * 10) + 1;
	imarr = new Timg[imnum + clnum];
	imrand(imarr, imnum, fsize);
	corerand(imarr, clnum, imnum);

	// Распределение областей относительно произвольных ядер
	clustbymin(imarr, clnum, imnum, fsize);

	int const stepcol = 255 / clnum;
	int elsize = SIZE / fsize;
	int	scrsize = elsize * fsize;

	// Отрисовка первой итерации
    sf::RenderWindow window1(sf::VideoMode(scrsize + 30, scrsize + 30), "First iteration");
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
			circle.setFillColor(sf::Color(imarr[i].clust%2*255, color, (imarr[i].clust % 2 + 1) * 255));
			circle.setPosition(imarr[i].x * (elsize), imarr[i].y * (elsize));
			window1.draw(circle);
		}
		circle.setFillColor(sf::Color(255, 255, 0));
		circle.setRadius(4 + elsize);
		circle.setOutlineThickness(3);
		circle.setOutlineColor(sf::Color(0, 0, 0));
		for (int i = imnum; i < imnum + clnum; i++)
		{
			circle.setPosition(imarr[i].x * (elsize), imarr[i].y * (elsize));
			window1.draw(circle);
		}
		circle.setOutlineThickness(0);
		window1.display();
	} while (window1.isOpen() && event.type != sf::Event::MouseButtonPressed);
	

	// Все остальные итерации
	int count = 1;
	while (!minstdevcore(imarr, clnum, imnum))
	{
		clustbymin(imarr, clnum, imnum, fsize);
		count++;
	}

	// Отрисовка последней итерации
	sf::RenderWindow window2(sf::VideoMode(scrsize + 30, scrsize + 30), "Last iteration: " + to_string(count));
	window2.setPosition(sf::Vector2i(SIZE, 0));
	while (window2.isOpen())
	{
		while (window2.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window2.close();
		}
		window2.clear();

		circle.setRadius(elsize);
		int color;
		for (int i = 0; i < imnum; i++)
		{
			color = stepcol * imarr[i].clust;
			circle.setFillColor(sf::Color(imarr[i].clust % 2 * 255, color, (imarr[i].clust % 2 + 1) * 255));
			circle.setPosition(imarr[i].x * (elsize), imarr[i].y * (elsize));
			window2.draw(circle);
		}
		circle.setFillColor(sf::Color(255, 255, 0));
		circle.setRadius(4 + elsize);
		circle.setOutlineThickness(3);
		circle.setOutlineColor(sf::Color(0, 0, 0));
		for (int i = imnum; i < imnum + clnum; i++)
		{
			circle.setPosition(imarr[i].x * (elsize), imarr[i].y * (elsize));
			window2.draw(circle);
		}
		circle.setOutlineThickness(0);
		window2.display();
	}

	delete[]imarr;
	return 0;
}