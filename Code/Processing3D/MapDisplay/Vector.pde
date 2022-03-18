class Vector{
  int x, y;
  float r;
  
  Vector(int x, int y, float r){
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  void render()
  {
    ellipse(x, y, r, r);
  }
}
