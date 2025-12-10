class Bola {
  Ponto p, alvo;
  boolean movendo, foiAtirada;
  boolean carregandoLancamento = false;
  float v, r, g, vx, vy, vento;
  float vBase, vAtual;
  float vMin = 1, vMax = 20;
  int tempoCarregamentoInicio;
  float tempoMaxCarregamento = 2000.0;
  
  // Constantes para estado (substituindo o enum)
  final int PARADA = 0;
  final int CARREGANDO = 1;
  final int EM_MOVIMENTO = 2;
  int estado = PARADA;
  
  Bola(Ponto np, float nv, float nr, float ng, float nVento) {
    this.p = np;
    this.v = nv;
    this.r = nr;
    this.g = ng;
    this.vento = nVento;
    vx = 0;
    vy = 0;
    alvo = null;
    movendo = false;
    foiAtirada = false;
    this.vBase = nv;
    this.estado = PARADA;
  }

  
  
  void comecaCarregamento() {
    if(estado == PARADA) {
      estado = CARREGANDO;
      this.carregandoLancamento = true;
      this.tempoCarregamentoInicio = millis();
      println("Iniciando carregamento...");
    }
  }
  
  void terminaCarregamento(Ponto alvo) {
    if(estado == CARREGANDO) {
      estado = EM_MOVIMENTO;
      carregandoLancamento = false;
      movendo = true;
      
      int tempoCarregamento = millis() - this.tempoCarregamentoInicio;
      float duracaoCarregamento = min(tempoCarregamento, tempoMaxCarregamento);
      
      float razaoCarregamento = duracaoCarregamento / tempoMaxCarregamento;
      this.v = vMin + (razaoCarregamento * (vMax - vMin));
      
      criaAlvo(alvo);
      println("Lançamento com velocidade: " + this.v);
    }
  }

  void carregamentoInimigo(float nv, Ponto alvo)
  {
    if(estado == PARADA)
    {
      estado = EM_MOVIMENTO;
      carregandoLancamento = false;
      movendo = true;
      this.v = nv;
      criaAlvo(alvo);
    }
  }
  
  void atualizaCarregamento() { // isso é só para motivos de print ou para mostrar na tela o float RazaodeCarga
    if(estado == CARREGANDO) {
      int tempoAtual = millis() - this.tempoCarregamentoInicio;
      float razaoDeCarga = min(tempoAtual, tempoMaxCarregamento) / tempoMaxCarregamento;
      println("Carregando: " + nf(razaoDeCarga * 100, 1, 1) + "%");
    }
  }
  
  void criaAlvo(Ponto p2) {
    this.alvo = p2;
    
    float teta = this.p.angPontos(p2);
    this.vx = this.v * cos(teta);
    this.vy = this.v * sin(teta);
    
    this.foiAtirada = false;
  }
  
  
  void processarEstado(Minhoca minhocaDona, Chao chao) {
    switch(estado) {
      case CARREGANDO:
        atualizaCarregamento();
        break;
        
      case EM_MOVIMENTO:
        moveBola(minhocaDona, chao);
        break;
        
      case PARADA:
        // Mantém a bola na minhoca
        if (minhocaDona != null) {
          this.p.x = minhocaDona.p.x + (minhocaDona.w)/2;
          this.p.y = minhocaDona.p.y + (minhocaDona.h)/2;
        }
        break;
    }
  }
  
  void moveBola(Minhoca minhocaDona, Chao chao) {
    // Verifica colisões
    colisaoParede();
    colisaoBolaChao(chao);
    if (minhocaDona != null) {
      colisaoMinhoca(minhocaDona);
    }
    
    // Aplica movimento
    if(movendo && alvo != null) {
      this.p.x += this.vx;
      this.p.y += this.vy;
      this.vx += this.vento;
      this.vy += this.g;
    }
    
    // Marca como atirada quando sai da área da minhoca
    if(!foiAtirada && movendo && minhocaDona != null) {
      if(this.p.y + this.r < minhocaDona.p.y || this.p.y - this.r > minhocaDona.p.y + minhocaDona.h) {
        this.foiAtirada = true;
        println("Bola foi atirada!");
      }
    }
  }
  
  void colisaoParede() {
    if(this.p.x + this.r >= width || this.p.x - this.r <= 0) {
      this.vx = -this.vx;
    }
    if(this.p.y + this.r >= height || this.p.y - this.r <= 0) {
      this.vy = -this.vy;
    } 
  }

  void colisaoBolaChao(Chao chao){
    float alturaChao = chao.getAlturaChao(this.p.x + this.r/2);
    if(this.p.y + this.r > alturaChao)
    {
      this.reseta(this.p);
    }

  }
  
  void colisaoMinhoca(Minhoca m) {
    if(!this.foiAtirada || estado != EM_MOVIMENTO) {
      return;
    }
    
    float testeX = this.p.x;
    float testeY = this.p.y;
    
    if(this.p.x < m.p.x) {
      testeX = m.p.x;
    }
    else if(this.p.x > m.p.x + m.w) {
      testeX = m.p.x + m.w;
    }
    
    if(this.p.y < m.p.y) {
      testeY = m.p.y;
    }
    else if(this.p.y > m.p.y + m.h) {
      testeY = m.p.y + m.h;
    }
    
    float distX = this.p.x - testeX;
    float distY = this.p.y - testeY;
    float distancia = sqrt((distX*distX) + (distY*distY));
    
    if(distancia <= this.r) {
      reseta(new Ponto(this.p.x, this.p.y));
      println("Colisão com minhoca!");
    }
  }
  
  void desenha() {
    if(this.movendo){
    circle(this.p.x, this.p.y, this.r * 2);
    }
  }
  
  void reseta(Ponto novoPonto) {
    this.p = novoPonto;
    this.vx = 0;
    this.vy = 0;
    this.movendo = false;
    this.foiAtirada = false;
    this.alvo = null;
    this.estado = PARADA;
    this.carregandoLancamento = false;
    this.v = vBase; // Reseta para velocidade base
  }
  
  // Método para obter nome do estado (para debug)
  String getEstadoNome() {
    switch(estado) {
      case PARADA: return "PARADA";
      case CARREGANDO: return "CARREGANDO";
      case EM_MOVIMENTO: return "EM_MOVIMENTO";
      default: return "DESCONHECIDO";
    }
  }
}
