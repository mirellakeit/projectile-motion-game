class Chao {
  int nSegmentos;
  int [] segmentosChaoX;
  int [] segmentosChaoY;
  int largura; //eh bom criar uma largura, porque se colocar só 'width' aqui, nao registra bem.
  int coefAngular = 50;
  int chaoMinimo = 300;

  Chao(int nseg, int nChaoMinimo, int nLargura)
  {
    this.nSegmentos = nseg;
    this.chaoMinimo = nChaoMinimo;
    this.largura = nLargura;
    segmentosChaoX = criaChaoX(this.nSegmentos);
    segmentosChaoY = criaChaoY(this.nSegmentos);
  }

  int [] criaChaoX(int n){
    int[] chaoX = new int[n + 1];
    
    for(int i = 0; i <= n; i++)
    {
      chaoX[i] = i * largura/n;
    }
    
    return chaoX;
  }
  
  int [] criaChaoY(int n){
    int[] chaoY = new int[n + 1];
    
    int a = 0;
    int b;
    for(int j = 0; j <= n; j++){
      b = (int) random(-6,5);
      chaoY[j] = (int) random(a, b);
      a = b;
      
    }

    return chaoY;
  }
  
  void desenhaChao(int nSeg){
    int x1, x2, y1, y2;
    for(int i = 0; i < nSeg; i++)
    {
      x1 = this.segmentosChaoX[i];
      y1 = this.chaoMinimo + (this.coefAngular * this.segmentosChaoY[i] );
      x2 = this.segmentosChaoX[i + 1];
      y2 = this.chaoMinimo + (this.coefAngular * this.segmentosChaoY[i + 1]);
      print("(x1,y1) = " + "( " + x1 + " , " + y1 + ") ; ");
      println("(x2,y2) = " + "( " + x2 + " , " + y2 + ")");

      line(x1, y1, x2, y2);
  }
  }
  
}

/*
int nSeg = 6;
int chaoMinimo = 300;

Chao chao = new Chao(nSeg, chaoMinimo);
chao.desenhaChao(chao.segmentosChaox, chao.segmentosChaoY, nSeg, chaoMinimo);
*/
