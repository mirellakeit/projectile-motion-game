
//classe ponto para representar coordenadas x e y
class Ponto
{
  float x, y;
  Ponto(float nx, float ny)
  {
    this.x = nx;
    this.y = ny;
  }
    //funcao que calcula o angulo entre dois pontos
    float angPontos(Ponto p2)
  {
    float dx = p2.x - this.x;
    float dy = p2.y - this.y;
    float teta = atan2(dy, dx);
    //println(degrees(teta));
    return teta;
  }
}
