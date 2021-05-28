public class game implements Comparable<game> //<>// //<>//
{
  double moves;
  int scale;
  int Num;
  int SpawnNum;
  int done;
  int k;
  int allowedmoves;
  PVector dir;
  double fitness;
  int applesate;
  int[] startingpos;
  int[] appleset;
  int appleprog;
  snake[] snake1;
  apple apple1;
  NetworkTools networkTools;
  Network net;

  @Override
    public int compareTo(game p) 
  {
    return Double.compare(this.fitness, p.GetFitness());
  }


  public game ()
  {
    this.moves = 0;
    this.allowedmoves = 100;
    this.fitness = 0;
    this.scale = 20;
    this.SpawnNum = 2;
    this.Num = this.SpawnNum + 1;
    this.done = 0;
    this.k = 0;
    this.appleset = new int[300];
    this.dir = new PVector(0, 0);
    this.snake1 = new snake[1000];
    this.apple1 = new apple(this);
    this.networkTools = new NetworkTools();
    this.net = new Network(new int[] {25, 18, 18, 4}, networkTools);//16,12,8,4
    this.applesate = 0;
    this.appleprog = 0;
    this.startingpos = new int[10];
  }

  public void draw()
  {
    if (this.done == 0)
    {

      background(0xff020795);
      fill(0xffFF352E);
      rect(this.apple1.x, this.apple1.y, this.scale, this.scale);
      for (int i = this.Num-1; i >= 1; i--)
      {
        this.snake1[i].drawSprite(this);
      }

      this.snake1[0].drawSprite(this);
    } else
    {
    }
  }
  public void logic()
  {
    // check and calculate 
    if (this.done == 0)
    {

      calculateMoves(this);
      movement(this);
      Check(this);

      this.moves++;
      if (this.allowedmoves-- <= 0)
      {
        this.done = 1;
      }
    }
  }
  public void setup()
  {
    int startingx;
    int startingy;
    this.snake1[0] = new snake();

    for (int i = 0; i <= this.SpawnNum; i++)
    {
      this.snake1[this.Num-i] = new snake();
    }

    int b = PApplet.parseInt(width/this.scale);
    int w = PApplet.parseInt(height/this.scale);
    startingx = PApplet.parseInt(random(b)) * this.scale;
    startingy = PApplet.parseInt(random(w)) * this.scale;
    if (generation < finalit)
    {
      this.snake1[0].x = startingx;
      this.snake1[0].y =  startingy;
      this.startingpos[0]= startingx;
      this.startingpos[1]= startingy;
    } else
    {
      this.snake1[0].x = this.startingpos[0];
      this.snake1[0].y =  this.startingpos[1];
    }


    this.apple1.spawnapple(this);
  }

  public double GetFitness()
  {
    return fitness;
  }
}

public class snake
{
  int x, y, xspeed, yspeed;

  public snake()
  {
    this.x = -40;
    this.y= 0;
    this.xspeed = 0;
    this.yspeed = 1;
  }

  public void drawSprite(game g)
  {
    fill(0xff5DEA00);
    rect(this.x, this.y, g.scale, g.scale);
  }

  public void move(game g)
  {
    this.xspeed = PApplet.parseInt(g.dir.x);
    this.yspeed = PApplet.parseInt(g.dir.y);
    this.x = this.x + this.xspeed * g.scale;
    this.y = this.y + this.yspeed * g.scale;

    if (this.x > width-g.scale || this.x < 0 || this.y > height-g.scale || this.y < 0)
    {
      g.done = 1;
      this.x = constrain(this.x, 0, width-g.scale);
      this.y =constrain(this.y, 0, height-g.scale);
    }
  }
}
public class apple
{
  int x, y;

  public apple(game g)
  {
    if (generation < finalit)
    {
      int i = PApplet.parseInt(random(width));
      int j = PApplet.parseInt(random(height));

      this.x = i;
      g.appleset[g.appleprog] = i;
      g.appleprog++;
      this.y = j;
      g.appleset[g.appleprog] = j;
      g.appleprog++;
    } else
    {
      this.x = g.appleset[g.appleprog];
      g.appleprog++;
      this.y = g.appleset[g.appleprog];
      g.appleprog++;
    }
  }

  public void spawnapple(game g)
  {
    if (generation < finalit)
    {
      int b = PApplet.parseInt(width/g.scale);
      int w = PApplet.parseInt(height/g.scale);
      int q = PApplet.parseInt(random(b)) * g.scale;
      int p = PApplet.parseInt(random(w)) * g.scale;
      this.x = q;
      this.y = p;

      for (int i = 0; i < g.Num; i++)
      {
        if (g.snake1[i].x == g.apple1.x && g.snake1[i].y == g.apple1.y)
        {
          spawnapple(g);
          break;
        }
      }

      g.appleset[g.appleprog] = q;
      g.appleprog++;
      g.appleset[g.appleprog] = p;
      g.appleprog++;
    } else
    {
      this.x = g.appleset[g.appleprog];
      g.appleprog++;
      this.y = g.appleset[g.appleprog];
      g.appleprog++;
    }
    for (int i = 0; i < g.Num; i++)
    {
      if (g.snake1[i].x == g.apple1.x && g.snake1[i].y == g.apple1.y)
      {
        spawnapple(g);
        break;
      }
    }
  }
}

public void Check(game g)
{
  for (int i = 1; i < g.Num; i++)
  {
    if (g.snake1[0].x == g.snake1[i].x && g.snake1[0].y == g.snake1[i].y)
    {
      g.done = 1;
      //draw();
      g.snake1[0].xspeed = 0;
      g.snake1[0].yspeed = 0;
    }
  }

  if (g.snake1[0].x == g.apple1.x && g.snake1[0].y == g.apple1.y)
  {
    g.applesate++;
    g.allowedmoves = 230;
    g.apple1.spawnapple(g);
    g.Num += g.SpawnNum;

    for (int i = 0; i <= g.SpawnNum; i++)
    {
      g.snake1[g.Num-i] = new snake();
    }
  }
}

public void movement(game g)
{
  //int i = 1;
  for (int i= g.Num-1; i>= 1; i--)
  {
    g.snake1[i].x = g.snake1[i-1].x;
    g.snake1[i].y = g.snake1[i-1].y;
  }

  g.snake1[0].move(g);
}

public void keyPressed()
{
  System.out.println("okay");
  if (keyCode == 'Q' )
  {
    if (generation <= finalit)
    {
      genkeeper = generation;
    }
    generation = finalit+1;
  } else if (keyCode == 'R')
  {
    if (generation > finalit)
    {
      frameRate(2000);
      generation = genkeeper;
    }
  } else if (keyCode == LEFT)
  {
    framerate -= 1;
  } else if (keyCode == RIGHT)
  {
    framerate += 1;
  }
  frameRate(framerate);
}
public PVector RandStart(NetworkTools nettools)
{
  int number = (int) (nettools.randomValue(1, 5));
  if (number == 1)
  {
    return new PVector(1, 0);
  }
  if (number == 2)
  {
    return new PVector(-1, 0);
  }
  if (number == 3)
  {
    return new PVector(0, 1);
  }
  if (number == 4)
  {
    return new PVector(0, -1);
  }
  return new PVector(0, 0);
}

public double Uprightsnakedist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;

  while (right == false)
  {
    if (ypos <= 0 || xpos >= width)
    {

      return -1;
    }

    for (int i = 1; i < g.Num; i++)
    {
      if (ypos == (g.snake1[i].y+9) && (g.snake1[i].x+9) == xpos)
      {
        right = true;
      }
    }
    ypos--;
    xpos++;
  }

  return(Math.sqrt((Math.pow((xpos-(g.snake1[0].x+9)), 2))  + (Math.pow((ypos-(g.snake1[0].y+9)), 2))));
}
public double Upleftsnakedist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;

  while (right == false)
  {
    if (ypos <= 0 || xpos <= 0)
    {

      return -1;
    }

    for (int i = 1; i < g.Num; i++)
    {
      if (ypos == (g.snake1[i].y+9) && (g.snake1[i].x+9) == xpos)
      {
        right = true;
      }
    }
    ypos--;
    xpos--;
  }

  return(Math.sqrt((Math.pow((xpos-(g.snake1[0].x+9)), 2))  + (Math.pow((ypos-(g.snake1[0].y+9)), 2))));
}
public double Downrightsnakedist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;

  while (right == false)
  {
    if (ypos >= height || xpos >= width)
    {

      return -1;
    }

    for (int i = 1; i < g.Num; i++)
    {
      if (ypos == (g.snake1[i].y+9) && (g.snake1[i].x+9) == xpos)
      {
        right = true;
      }
    }
    ypos++;
    xpos++;
  }

  return(Math.sqrt((Math.pow((xpos-(g.snake1[0].x+9)), 2))  + (Math.pow((ypos-(g.snake1[0].y+9)), 2))));
}

public double Downleftsnakedist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos >= height || xpos <= 0)
    {

      return -1;
    }

    for (int i = 1; i < g.Num; i++)
    {
      if (ypos == (g.snake1[i].y+9) && (g.snake1[i].x+9) == xpos)
      {
        right = true;
      }
    }
    ypos++;
    xpos--;
  }

  return(Math.sqrt((Math.pow((xpos-(g.snake1[0].x+9)), 2))  + (Math.pow((ypos-(g.snake1[0].y+9)), 2))));
}
public int Rightdist(game g)
{
  int xpos = g.snake1[0].x;
  boolean right = false;
  while (right == false)
  {
    if (xpos + g.scale >= (width))
    {
      right = true;
    }

    xpos += g.scale;
  }
  return (xpos - (g.snake1[0].x+g.scale));
}
public int Leftdist(game g)
{

  int xpos = g.snake1[0].x;
  boolean right = false;
  while (right == false)
  {
    if (xpos <= 0)
    {
      right = true;
    }

    xpos -= g.scale;
  }
  return((-xpos + (g.snake1[0].x-g.scale)));
}
public int Updist(game g)
{
  int ypos = g.snake1[0].y;
  boolean right = false;
  while (right == false)
  {
    if (ypos <= 0)
    {
      right = true;
    }

    ypos-=g.scale;
  }
  return(-ypos + (g.snake1[0].y - g.scale));
}

public int Downdist(game g)
{
  int ypos = g.snake1[0].y;
  boolean right = false;
  while (right == false)
  {
    if (ypos+g.scale >= height)
    {
      right = true;
    }

    ypos+=g.scale;
  }
  return(ypos - (g.snake1[0].y + g.scale));
}
public int Rightsnakedist(game g)
{
  int xpos = g.snake1[0].x;
  boolean right = false;
  while (right == false)
  {
    if (xpos + g.scale >= (width))
    {
      return(0);
    }

    for (int i = 1; i < g.Num; i++)
    {
      if (xpos == g.snake1[i].x && g.snake1[i].y == g.snake1[0].y )
      {
        right = true;
      }
    }
    xpos += g.scale;
  }
  return (xpos - (g.snake1[0].x+g.scale));
}
public int Leftsnakedist(game g)
{

  int xpos = g.snake1[0].x;
  boolean right = false;
  while (right == false)
  {
    if (xpos <= 0)
    {
      return(0);
    }

    for (int i = 1; i < g.Num; i++)
    {
      if (xpos == g.snake1[i].x && g.snake1[i].y == g.snake1[0].y )
      {
        right = true;
      }
    }
    xpos -= g.scale;
  }
  return((-xpos + (g.snake1[0].x-g.scale)));
}
public int Upsnakedist(game g)
{
  int ypos = g.snake1[0].y;
  boolean right = false;
  while (right == false)
  {
    if (ypos <= 0)
    {
      return(0);
    }
    for (int i = 1; i < g.Num; i++)
    {
      if (ypos == g.snake1[i].y && g.snake1[i].x == g.snake1[0].x )
      {
        right = true;
      }
    }
    ypos-=g.scale;
  }
  return(-ypos + (g.snake1[0].y - g.scale));
}

public int Downsnakedist(game g)
{
  int ypos = g.snake1[0].y;
  boolean right = false;
  while (right == false)
  {
    if (ypos+g.scale >= height)
    {
      return(0);
    }
    for (int i = 1; i < g.Num; i++)
    {
      if (ypos == g.snake1[i].y && g.snake1[i].x == g.snake1[0].x )
      {
        right = true;
      }
    }
    ypos+=g.scale;
  }
  return(ypos - (g.snake1[0].y + g.scale));
}
public void turnRight(game g)
{
  if (g.snake1[0].xspeed == 1)
  {
    g.dir = new PVector(0, 1);
  } else if (g.snake1[0].xspeed == -1)
  {
    g.dir = new PVector(0, -1);
  } else if (g.snake1[0].yspeed == -1)
  {
    g.dir = new PVector(1, 0);
  } else if (g.snake1[0].yspeed == 1)
  {
    g.dir = new PVector(-1, 0);
  }
}
public void turnLeft(game g)
{
  if (g.snake1[0].xspeed == 1)
  {
    g.dir = new PVector(0, -1);
  } else if (g.snake1[0].xspeed == -1)
  {
    g.dir = new PVector(0, 1);
  } else if (g.snake1[0].yspeed == -1)
  {
    g.dir = new PVector(-1, 0);
  } else if (g.snake1[0].yspeed == 1)
  {
    g.dir = new PVector(1, 0);
  }
}

public int FoodUp(game g)
{
  int ypos = g.snake1[0].y;
  boolean right = false;
  boolean found = false;
  while (right == false && found == false)
  {

    if (ypos == -800)
    {
      return(0);
    }
    if (ypos == g.apple1.y && g.apple1.x == g.snake1[0].x )
    {
      found = true;
    }
    ypos-=g.scale;
  }
  if (found == true)
  {
    return (-ypos + (g.snake1[0].y - g.scale));
  }
  return 0;
}

public int FoodRight(game g)
{
  int xpos = g.snake1[0].x;
  boolean right = false;
  boolean found = false;
  while (right == false && found == false)
  {

    if (xpos == 900)
    {
      return(0);
    }
    if (xpos == g.apple1.x && g.apple1.y == g.snake1[0].y )
    {
      found = true;
    }
    xpos+=g.scale;
  }

  if (found == true)
  {
    return (xpos - (g.snake1[0].x + g.scale));
  }
  return 0;
}
public int FoodDown(game g)
{
  int ypos = g.snake1[0].y;
  boolean right = false;
  boolean found = false;
  while (right == false && found == false)
  {

    if (ypos == 900)
    {
      return(0);
    }
    if (ypos == g.apple1.y && g.apple1.x == g.snake1[0].x )
    {
      found = true;
    }
    ypos+=g.scale;
  }
  if (found == true)
  {
    return (ypos - (g.snake1[0].y + g.scale));
  }
  return 0;
}
public int FoodLeft(game g)
{
  int xpos = g.snake1[0].x;
  boolean right = false;
  boolean found = false;
  while (right == false && found == false)
  {

    if (xpos == -900)
    {
      return(0);
    }
    if (xpos == g.apple1.x && g.apple1.y == g.snake1[0].y )
    {
      found = true;
    }
    xpos-=g.scale;
  }
  if (found == true)
  {
    return (-xpos + (g.snake1[0].x - g.scale));
  }
  return 0;
}

public double Upleftdist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  int applex = g.apple1.x + 9;
  int appley = g.apple1.y + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos <= 0 || xpos <= 0)
    {

      return 0;
    }

    if (abs(ypos - appley) <= (2) && abs(xpos - applex) <= (2))
    {
      right = true;
    }

    ypos--;
    xpos--;
  }

  return(Math.sqrt((Math.pow((xpos-g.snake1[0].x), 2))  + (Math.pow((ypos-g.snake1[0].y), 2))));
}
public double Uprightdist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  int applex = g.apple1.x + 9;
  int appley = g.apple1.y + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos <= 0 || xpos >= width)
    {

      return 0;
    }

    if (abs(ypos - appley) <= (2) && abs(xpos - applex) <= (2))
    {
      right = true;
    }

    ypos--;
    xpos++;
  }

  return(Math.sqrt((Math.pow((xpos-g.snake1[0].x), 2))  + (Math.pow((ypos-g.snake1[0].y), 2))));
}
public double Downrightdist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  int applex = g.apple1.x + 9;
  int appley = g.apple1.y + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos >= height || xpos >= width)
    {
      return 0;
    }

    if (abs(ypos - appley) <= (2) && abs(xpos - applex) <= (2))
    {
      right = true;
    }

    ypos++;
    xpos++;
  }

  return(Math.sqrt((Math.pow((xpos-g.snake1[0].x), 2))  + (Math.pow((ypos-g.snake1[0].y), 2))));
}

public double Downleftdist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  int applex = g.apple1.x + 9;
  int appley = g.apple1.y + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos >= height || xpos <= 0)
    {

      return 0;
    }

    if (abs(ypos - appley) <= (2) && abs(xpos - applex) <= (2))
    {
      right = true;
    }

    ypos++;
    xpos--;
  }

  return(Math.sqrt((Math.pow((xpos-g.snake1[0].x), 2))  + (Math.pow((ypos-g.snake1[0].y), 2))));
}
public double Downleftwalldist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos >= height || xpos <= 0)
    {

      right=true;
      ;
    }
    ypos++;
    xpos--;
  }

  return(Math.sqrt((Math.pow((xpos-(g.snake1[0].x+9)), 2))  + (Math.pow((ypos-(g.snake1[0].y+9)), 2))));
}
public double Downrightwalldist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos >= height || xpos >= width)
    {

      right=true;
      ;
    }
    ypos++;
    xpos++;
  }

  return(Math.sqrt((Math.pow((xpos-(g.snake1[0].x+9)), 2))  + (Math.pow((ypos-(g.snake1[0].y+9)), 2))));
}
public double Upleftwalldist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos <= 0 || xpos <= 0)
    {

      right=true;
      ;
    }
    ypos--;
    xpos--;
  }

  return(Math.sqrt((Math.pow(xpos-(g.snake1[0].x+9), 2))  + (Math.pow(ypos-(g.snake1[0].y+9), 2))));
}
public double Uprightwalldist(game g)
{
  int ypos = g.snake1[0].y + 9;
  int xpos = g.snake1[0].x + 9;
  boolean right = false;
  while (right == false)
  {
    if (ypos <= 0 || xpos >= width)
    {

      right=true;
      ;
    }
    ypos--;
    xpos++;
  }

  return(Math.sqrt((Math.pow((xpos-(g.snake1[0].x+9)), 2))  + (Math.pow((ypos-(g.snake1[0].y+9)), 2))));
}
public int highestindex(double output[])
{
  double high =2;
  int j = 0; 
  high = output[0]; 
  for (int i = 1; i < output.length; i++)
  {
    if (output[i] > high)
    {
      high = output[i];
      j = i;
    }
  }

  return j;
}

public game[] Selection(game best, game best2, game best3, game best4)
{
  int rank1 = (int) (current_game.networkTools.randomValue(1, 5));
  int rank2 = (int) (current_game.networkTools.randomValue(1, 5));

  game parent1 = new game();
  game parent2 = new game();
  while (rank1 == rank2)
  {
    rank1 = (int) (current_game.networkTools.randomValue(1, 5));
    rank2 = (int) (current_game.networkTools.randomValue(1, 5));
  }
  if (rank1 == 1)
  {
    parent1.net = best.net.Copy(current_game.networkTools);
  } else if (rank1 == 2)
  {
    parent1.net = best2.net.Copy(current_game.networkTools);
  } else if (rank1 == 3)
  {
    parent1.net = best3.net.Copy(current_game.networkTools);
  } else if (rank1 == 4)
  {
    parent1.net = best4.net.Copy(current_game.networkTools);
  }
  if (rank2 == 1)
  {
    parent2.net = best.net.Copy(current_game.networkTools);
  } else if (rank2 == 2)
  {
    parent2.net = best2.net.Copy(current_game.networkTools);
  } else if (rank2 == 3)
  {
    parent2.net = best3.net.Copy(current_game.networkTools);
  } else if (rank2 == 4)
  {
    parent2.net = best4.net.Copy(current_game.networkTools);
  }
  return new game[] {parent1, parent2};
}

public int Selection2(game[] pop)
{
  int i;
  float Current = 0;
  Psum = pop[0].networkTools.randomValue(0, sumfit);
  for (i = 0; i < pop.length; i++)
  {

    Current += pop[i].fitness;
    if (Current > Psum)
    {
      return i;
    }
  }

  return 0;
}
public void calculateMoves(game g)
{
  double output[];
  int j;

  output = g.net.calculate(g.Num, Downleftwalldist(g), Downrightwalldist(g), Upleftwalldist(g), Uprightwalldist(g), Downleftsnakedist(g), Downrightsnakedist(g), Upleftsnakedist(g), Uprightsnakedist(g), Downleftdist(g), Downrightdist(g), Upleftdist(g), Uprightdist(g), FoodDown(g), FoodUp(g), FoodRight(g), FoodLeft(g), Downdist(g), Updist(g), Rightdist(g), Leftdist(g), Downsnakedist(g), Upsnakedist(g), Rightsnakedist(g), Leftsnakedist(g));
  j = highestindex(output);

  if (j == 0)
  {
    g.dir = new PVector(0, 1);
  }
  if (j == 1)
  {
    g.dir = new PVector(0, -1);
  }
  if (j == 2)
  {
    g.dir = new PVector(1, 0);
  }
  if (j == 3)
  {
    g.dir = new PVector(-1, 0);
  }
  if (generation > finalit)
  {

    println(j);
    System.out.println(Arrays.toString(output));
  }
}


/////////////////////////
game current_game = new game();
game current_game2 = new game();
Network mediary;     
game best_game = new game();
game best2= new game();
game best3= new game();
game best4= new game();
game[] parentpool;
game[] potparents;
Network[] childpool;
game[] population;
game[] selection;
game copy = new game();
game copy2 = new game();
game copy3 = new game();
game copy4 =new game();
Random rand = new Random();
NetworkTools netTools;

int framerate = 1000;
int genkeeper = 0;
int group = 2000;
int playthroughs = 0;
int first_iteration = 0;
int generation = 0;
int finalit = 100000;
float percentparent;
double averagefit = 0;
double sumfit = 0;
double Psum = 0;
int blakn = 0;
int i = 0;
float mutationrate = .05f; 
float defmut = mutationrate;
int bestlife = 0;
/////////////////////////
public void draw()
{
  int p =0;
  int qwe = 0;
  if (generation <= finalit)
  {
    for (i = 0; i < group; i++)
    {

      while (population[i].done == 0)
      {
        population[i].logic();
      }
      if (population[i].moves >80)
      {
        population[i].fitness = (population[i].moves) + (Math.pow(2, population[i].applesate) + Math.pow(population[i].applesate, 2.1f)*500) - ((Math.pow((.25f * population[i].moves), 1.3f) * Math.pow(population[i].applesate, 1.2f)));
      } else
      {
        population[i].fitness = (population[i].moves)*(Math.pow(2, population[i].applesate));
      }
    }



    Arrays.sort(population, Collections.reverseOrder());


    if (population[0].fitness < best_game.fitness)
    {
    } else
    {
      best_game.net = population[0].net.Copy(best_game.networkTools);
      best_game.appleset = population[0].appleset;
      best_game.applesate = population[0].applesate;
      best_game.startingpos = population[0].startingpos;
      best_game.fitness = population[0].fitness;
    }


    for (int i = 0; i < group; i++)
    {
      sumfit += population[i].fitness;
    }

    System.arraycopy(population, 0, potparents, 0, ((int) (group)));
    for (i = 0; i < group/2; i++)
    {
      qwe = Selection2(potparents);
      parentpool[i]= potparents[qwe];
    }

    for (int i = 0; i < 2; i++ )
    {
      for (int j = 0; j < (group/2); j++)
      {
        p = parentpool[0].net.Crossyover(parentpool[j].net, parentpool[++j].net, childpool, p, mutationrate, population[0].networkTools);
      }
    }

    generation++;
    averagefit= sumfit/group;
    System.out.println("generation " + generation);
    System.out.println("average fitness " + averagefit);
    System.out.println("best fitness " + best_game.fitness);
    averagefit = 0;
    sumfit = 0;
    for (int i = 0; i < 3; i++)
    {
      System.out.println(i + " Best Fitness is " + population[i].fitness);
      if (i == 0)
      {
        System.out.println(i + " moves " + population[i].moves);
        System.out.println(i + " apples " + population[i].applesate);
      }
    }
    for (int i = 0; i < group; i++)
    {
      population[i]= new game();
      population[i].setup();
      population[i].net = childpool[i].Copy(population[0].networkTools);
    }
  } else
  {
    frameRate(25);
    if (current_game.done == 1)
    {
      current_game = new game();
      current_game.appleset = best_game.appleset;
      current_game.applesate = best_game.applesate;
      current_game.startingpos = best_game.startingpos;
      current_game.net = best_game.net.Copy(population[0].networkTools);
      current_game.setup();
    }
    current_game.logic();
    current_game.draw();
  }
}

public void setup()
{

  background(0);
  frameRate(2500);
  size(400, 300);
  
  population = new game[group];
  parentpool = new game[group];
  childpool = new Network[group];
  potparents = new game[group];

  System.out.println("here");
  best_game.setup();
  current_game.setup();
  current_game2.setup();

  for (int i = 0; i < group; i++)
  {
    population[i] = new game();
    population[i].setup();
  }
}
