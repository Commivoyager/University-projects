#define _CRT_SECURE_NO_WARNINGS
#include <SFML/Graphics.hpp>

#include <iostream>
#define xnum 100
#define xrange xnum*1.5
//#define mindiff 0.000000001
#define sigmnum 4
#define stepsnum 333
#define pi 3.1416
typedef struct
{
    float x;
    float y;
}xpoint;

void getpriorprob(float&  p1, float& p2)
{
    char str[1000]{};    
    do
    {
        printf("\nEnter priori probability to the 1-st class (it must be <= 1 and >= 0): ");
        scanf("%f", &p1);
        //p1 = 0.5;
    } while (p1 > 1 || p1 < 0);
    p2 = 1 - p1;
}

void distribrand(float& math, float& dev, int step)
{
    math = 0;
    dev = 0;
    int* xarr = (int*)malloc(xnum*sizeof(int));
    for (int i = 0; i < xnum; i++)
    {
        xarr[i] = rand() % xrange + step;
        math += xarr[i];
    }
    math /= (float)xnum;
    for (int i = 0; i < xnum; i++)
    {
        dev += (xarr[i] - math) * (xarr[i] - math);
    }
    dev /= (float)xnum;
    dev = sqrt(dev);
    printf("\nmath: %f\ndev: %f\n", math, dev);
    free(xarr);
}

void fillxarr(xpoint* arr, int sizexarr, float xstart, float xstep, float m, float d, float p)
{
    float x = xstart;
    for (int i = 0; i < sizexarr; i++)
    {
        arr[i].x = x;
        float temp = -0.5 * (x - m) * (x - m) / d / d;
        arr[i].y = p * exp(temp) / d / sqrt(2 * pi);
        x += xstep;
    }
}

int findboarditer(xpoint* arr1, xpoint* arr2, int sizexarr)
{
    int ind = 0;
    bool flag = arr1[ind].y > arr2[ind].y;
    do
    {
        ind++;
    } while (flag == (arr1[ind].y > arr2[ind].y));
    /*for (int i = ind - 5; i < ind + 5; i++)
    {
        printf("\n%d\n", i);
        printf("\n\n1: %f\n2: %f", arr1[i].x, arr2[i].x);
        printf("\n1: %f\n2: %f", arr1[i].y, arr2[i].y);
        printf("\n=====================================================\n");
    }
    printf("\n%d\n", ind);*/
    return ind;
}

float integral(xpoint* arr, int startind, int finind, float xstep)
{
    float res = 0;
    for (int i = startind; i < finind - 1; i++)
    {
        res += xstep * arr[i].y;
    }
    return res;
}

int main()
{
    srand(time(NULL));
    float p1, p2;
    float math1, dev1, math2, dev2;

    getpriorprob(p1, p2);
    distribrand(math1, dev1, 0);
    distribrand(math2, dev2, dev1);

    
    float xstart = math1 - dev1 * sigmnum;
    float rangewidth = math2 + dev2 * sigmnum - xstart;
    float xstep = rangewidth / stepsnum;
    int sizexarr = stepsnum+1;
    xpoint* x1arr = (xpoint*)malloc(sizexarr * sizeof(xpoint));
    xpoint* x2arr = (xpoint*)malloc(sizexarr * sizeof(xpoint));
    
    fillxarr(x1arr, sizexarr, xstart, xstep, math1, dev1, p1);
    
    fillxarr(x2arr, sizexarr, xstart, xstep, math2, dev2, p2);

    int indboard = findboarditer(x1arr, x2arr, sizexarr);
    
    float falsealarm1, skipdetect1;
    printf("\n\nThe probability of a false alarm for the 1-st class: \t%f", falsealarm1 = integral(x2arr, 0, indboard, xstep));
    printf("\nThe probability of missing detection for the 1-st class: \t%f", skipdetect1 = integral(x1arr, indboard, sizexarr, xstep));
    printf("\nThe probability of a false alarm for the 2-nd class: \t%f", skipdetect1);
    printf("\nThe probability of missing detection for the 2-nd class: \t%f\n", falsealarm1);
    printf("\n\nResult: %f", falsealarm1 + skipdetect1);

 
    int const scrheight = 500;
    int const scrwidth = 1500;
    int h = scrheight;
    sf::RenderWindow window(sf::VideoMode(scrwidth, scrheight), "Lab 3");
    //sf::CircleShape shape(100.f);
    //shape.setFillColor(sf::Color::Green);
    /*int x0 = 0, y0 = -(0 + 900);
    int x1 = 1000, y1 = -1000 + 900;*/
    int x0 = 0, y0 = h;
    int x1 = 1000, y1 = -1000+h;
    sf::VertexArray lines(sf::Lines, sizexarr<<1);
    sf::VertexArray lines2(sf::Lines, (sizexarr << 1)-1);
    // Определение координат линий
    for (int i = 0; i < sizexarr; i++)
    {
        lines[i].position = sf::Vector2f((x1arr[i].x) * 3 + 200, -(x1arr[i].y) * 90000 + h);
        lines[i].color = sf::Color::Yellow;
    }
    for (int i = sizexarr, j = 0; i < sizexarr << 1; i++, j++)
    {
        lines[i].position = sf::Vector2f((x2arr[j].x) * 3 + 200, -(x2arr[j].y) * 90000 + h);
        lines[i].color = sf::Color::Green;
    }

    ///////////////////////////////
    for (int i = 0; i < sizexarr-2; i++)
    {
        lines2[i].position = sf::Vector2f((x1arr[i+1].x) * 3 + 200, -(x1arr[i+1].y) * 90000 + h);
        lines2[i].color = sf::Color::Yellow;
    }
    for (int i = sizexarr-2, j = 1; i < (sizexarr << 1) - 2; i++, j++)
    {
        lines2[i].position = sf::Vector2f((x2arr[j].x) * 3 + 200, -(x2arr[j].y) * 90000 + h);
        lines2[i].color = sf::Color::Green;
    }
    
    sf::VertexArray lines3(sf::Lines, 2);
    lines3[0].position = sf::Vector2f(0, h);
    lines3[1].position = sf::Vector2f(scrwidth, h);
    lines3[0].color = sf::Color::Black;
    lines3[1].color = sf::Color::Black;
    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }

        window.clear();
        



      
        window.draw(lines);
        window.draw(lines2);
        window.draw(lines3);
        window.display();
    }
      
    free(x1arr);
    free(x2arr);
    return 0;
}