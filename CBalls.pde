
/**
 * Container class for a number (totalball) of Ball objects
 */
public class CBalls {

  boolean mousedown   = false;

  Ball[] ball;

  CBalls(PApplet pApp, int totalball) {
    minim = new Minim(pApp);

    ball = new Ball[totalball];
    for (int bn=0; bn < ball.length; bn++) 
      ball[bn] = new Ball(minim, bn);
  }

  void draw() 
  {
    // draw the balls
    for (int bn=0; bn < ball.length; bn++) 
      ball[bn].draw();
  } 

 void game_physics() {
    for (int bn = 0; bn < ball.length; bn++) {
      ball[bn].game_physics();
    }
    detectCollisions();  
  }

  void detectCollisions() {
    for (int i = 0; i < ball.length; i++) {
      for (int j = i + 1; j < ball.length; j++) {
        Ball b1 = ball[i];
        Ball b2 = ball[j];

        // Distanz zwischen den Bällen
        // die Differenz der x & y -Koordinaten          
        // Formel um Distanz zu berechnen: sqrt((b2.sx-b1.sx)^2 + (b2.sy-b1.sy)^2)

        float dx = (float)(b1.sx - b2.sx);
        float dy = (float)(b1.sy - b2.sy);
        float distance = (float)Math.sqrt(dx * dx + dy * dy);  


        if (distance < b1.Radius() + b2.Radius()) {
          // Simple elastic collision response
          float overlap = 0.5f * (distance - b1.Radius() - b2.Radius());

          // Adjust positions to separate balls
          b1.sx -= overlap * (b1.sx - b2.sx) / distance;
          b1.sy -= overlap * (b1.sy - b2.sy) / distance;
          b2.sx += overlap * (b1.sx - b2.sx) / distance;
          b2.sy += overlap * (b1.sy - b2.sy) / distance;

          // Einheitsvektor, zeigt die Richtung des Vektors an
          float nx = dx / distance;
          float ny = dy / distance;

          // Relative Geschwindigkeit
          float dvx = (float)(b1.vx - b2.vx);
          float dvy = (float)(b1.vy - b2.vy);

          // Skalarprodukt zweier Vektoren 
          float skalarprodukt = dvx * nx + dvy * ny;

          if (skalarprodukt > 0) continue;

          // Calculate the impulse scalar
          float impulse = 2 * skalarprodukt / (float)(b1.MASS + b2.MASS);

          // Apply the impulse to each ball's velocity
          b1.vx -= impulse * b2.MASS * nx;
          b1.vy -= impulse * b2.MASS * ny;
          b2.vx += impulse * b1.MASS * nx;
          b2.vy += impulse * b1.MASS * ny;
        }
      }
    }
  }

  void stop()
  {
    // make sure to close all AudioPlayer objects
    for (int bn=0; bn < ball.length; bn++) { 
      ball[bn].kick.close(); 
      ball[bn].snare.close();
    }  

    minim.stop();
  }

  /* Clicked mouse */
  void Mouse ()
  {
    if (mouseButton == LEFT) System.out.printf("State: MOUSE_DOWN\n");
    for (int bn=0; bn < ball.length; bn++) { 
      ball[bn].Mouse();
    }
  }

  /* Released mouse */
  void MouseUp ()
  {
    System.out.printf("State: MOUSE_RELEASED\n");
    for (int bn=0; bn < ball.length; bn++) { 
      ball[bn].MouseUp();
    }
  }
}