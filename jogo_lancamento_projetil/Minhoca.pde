class Minhoca {
  Ponto p;
  Bola b;
  float v, w, h;
  
  Minhoca(Ponto np, Bola nb) {
    this.p = np;
    this.b = nb;
    this.v = 5;
    this.w = 20;
    this.h = 40;
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

  void colisaoMinhocaChao(Chao chao){
    
    float alturaChao = chao.getAlturaChao(this.p.x + this.w/w);

    this.p.y = alturaChao - this.h;
    
  }

  void desenha() {
    rect(this.p.x, this.p.y, this.w, this.h);
  }
}
