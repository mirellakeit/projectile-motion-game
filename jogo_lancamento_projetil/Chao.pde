class Chao {
  int nSegmentos;
  int [] segmentosChaoX;
  int [] segmentosChaoY;
  int largura; //eh bom criar uma largura, porque se colocar só 'width' aqui, nao registra bem.
  int coefAngular = 50;
  int chaoMinimo = 300;

  //o chao é basicamente uma serie de segmentos de reta entre pontos aleatorios em y.
  Chao(int nseg, int nChaoMinimo, int nLargura)
  {
    this.nSegmentos = nseg;
    this.chaoMinimo = nChaoMinimo;
    this.largura = nLargura;
    segmentosChaoX = criaChaoX(this.nSegmentos);
    segmentosChaoY = criaChaoY(this.nSegmentos);
  }

  //funcao para criar os arrays de pontos x do chao. por enquanto eles sempre teram o mesmo espaçamento em x.
  int [] criaChaoX(int n){
    int[] chaoX = new int[n + 1];
    
    for(int i = 0; i <= n; i++)
    {
      chaoX[i] = i * largura/n;
    }
    
    return chaoX;
  }
  
  //funcao para criar os arrays de pontos y do chao, com valores aleatorios.
  int [] criaChaoY(int n){
    int[] chaoY = new int[n + 1];
    
    chaoY[0] = 0;
    for(int j = 1; j <= n; j++){
      chaoY[j] = (int) random(-3, 4);
      
    }

    return chaoY;
  }
  
  //funcao que retorna a altura do chao em um ponto x qualquer, fazendo interpolação linear entre os segmentos.
  float getAlturaChao(float x)
  {
    int segmento = (int) (x / (this.largura / this.nSegmentos));

    //pra nao ir out of bounds
    if(segmento < 0)
    {
      segmento = 0;
    }
    if(segmento >= this.nSegmentos)
    {
      segmento = this.nSegmentos - 1;
    }


    float x1 = segmentosChaoX[segmento];
    float y1 = chaoMinimo + (coefAngular * segmentosChaoY[segmento]);
    float x2 = segmentosChaoX[segmento + 1];
    float y2 = chaoMinimo + (coefAngular * segmentosChaoY[segmento + 1]);

    float t = (x - x1) / (x2 - x1);
    return y1 + t * (y2 - y1);

  }

  //funcao que desenha o chao.
  void desenhaChao(int nSeg){
    int x1, x2, y1, y2;
    for(int i = 0; i < nSeg; i++)
    {
      x1 = this.segmentosChaoX[i];
      y1 = this.chaoMinimo + (this.coefAngular * this.segmentosChaoY[i] );
      x2 = this.segmentosChaoX[i + 1];
      y2 = this.chaoMinimo + (this.coefAngular * this.segmentosChaoY[i + 1]);
      //print("(x1,y1) = " + "( " + x1 + " , " + y1 + ") ; ");
      //println("(x2,y2) = " + "( " + x2 + " , " + y2 + ")");

      line(x1, y1, x2, y2);
  }
  }
  
}