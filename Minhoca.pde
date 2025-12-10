class Minhoca {
  Ponto p;
  Bola b;
  float v, w, h;
  
  Minhoca(Ponto np, Bola nb, float nw, float nh) {
    this.p = np;
    this.b = nb;
    this.v = 2;
    this.w = nw;
    this.h = nh;
  }
  
  void lancamentoInimigo(Bola b, Minhoca mAlvo) {
    
    float distX = (mAlvo.p.x + mAlvo.w/2) - (this.p.x + this.w/2);
    float distY = (mAlvo.p.y + mAlvo.h/2) - (this.p.y + this.h/2);
    float distancia = sqrt((distX*distX) + (distY*distY));
    
    println("distancia = " + distancia);
    float vMinInimigo = sqrt(distancia * b.g / sin(2 * radians(45)));
    println("vMinInimigo = " + vMinInimigo);
    
    if(vMinInimigo >= b.vMax) 
    {
      println("Entrou no primeiro if");
      while(vMinInimigo >= b.vMax) 
      {
        this.p.x -= 5;
        this.colisaoMinhocaChao(chao);
      }
    }
    else 
    {
      println("entrou no else");
      float vo = random(vMinInimigo, b.vMax);
      float teta = asin((b.g * distancia) / (vo * vo));
      float xAlvo, yAlvo;
      println("vo = " + vo + "; teta = " + teta);
      float distanciaMira = 100;
      float direcao = (mAlvo.p.x > this.p.x) ? 1 : -1;
      xAlvo = this.p.x + this.w/2 + cos(teta) * distanciaMira * direcao;
      yAlvo = this.p.y + this.h/2 + sin(teta) * distanciaMira;
        yAlvo = teta * xAlvo;
        b.carregamentoInimigo(vo, new Ponto(xAlvo, yAlvo));
        println("x = " + xAlvo, "y = " + yAlvo);
    }
  }

  void colisaoParede() {
    if(this.p.x + this.w >= width) {
      this.p.x = width - this.w;
    }
    if(this.p.x <= 0) {
      this.p.x = 0;
    }
  }
  
  void mover(Chao chao) {
    this.colisaoParede();
    if(keyPressed) {
      if(keyCode == LEFT) {
        this.p.x -= this.v;
      }
      if(keyCode == RIGHT) {
        this.p.x += this.v;
      }
     this.colisaoMinhocaChao(chao);

      
    }
  }
  
  void atualizarInimigo(Chao chao){
      b.processarEstado(this, chao);
    
    // Mostra ângulo se estiver carregando
    if(b.estado == b.CARREGANDO) {
      mostrarAnguloTiro(new Ponto(mouseX, mouseY));
    }
  }

  void atualizar(Chao chao) {
    mover(chao);
    
    // Processa o estado da bola (MÉTODO SIMPLIFICADO)
    b.processarEstado(this, chao);
    
    // Mostra ângulo se estiver carregando
    if(b.estado == b.CARREGANDO) {
      mostrarAnguloTiro(new Ponto(mouseX, mouseY));
    }
  }
  
  void mostrarAnguloTiro(Ponto alvo) {
    float centroX = this.p.x + this.w/2;
    float centroY = this.p.y + this.h/2;
    float angulo = this.p.angPontos(alvo);
    
    float linhaX = centroX + cos(angulo) * 50;
    float linhaY = centroY + sin(angulo) * 50;
    
    stroke(255, 0, 0);
    line(centroX, centroY, linhaX, linhaY);
    stroke(0);
  }
  
  void mostrarCarregamento(Bola b)
  {
    if(b.estado == 1){
    int tempoAtual = millis() - b.tempoCarregamentoInicio;
    float razaoDeCarga = min(tempoAtual, b.tempoMaxCarregamento) / b.tempoMaxCarregamento;
    String texto = nf(razaoDeCarga * 100, 1, 1) + "%";
    text(texto, this.p.x, this.p.y - 15);
    }
  }

  void colisaoMinhocaChao(Chao chao){
    
    float alturaChao = chao.getAlturaChao(this.p.x + this.w/w);

    this.p.y = alturaChao - this.h;
    
  }

  void desenha() {
    rect(this.p.x, this.p.y, this.w, this.h);
  }
}
