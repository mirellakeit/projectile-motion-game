class Bola {
  Ponto p, alvo;  
  boolean movendo, foiAtirada;
  boolean carregandoLancamento = false;
  float v, r, g, vx, vy, vento;
  float vBase, vAtual;
  float vMin = 1, vMax = 20;
  int tempoCarregamentoInicio;
  float tempoMaxCarregamento = 2000.0;
  

  final int PARADA = 0;
  final int CARREGANDO = 1;
  final int EM_MOVIMENTO = 2;
  int estado = PARADA;
  
  //construtora
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

  
  //essa funcao começa no mouseCLick e inicia o carregamento da bola. O tempo é salvo no atributo this.tempoCarregamentoInicio a partir da função millis()
  void comecaCarregamento() {
    if(estado == PARADA) {
      estado = CARREGANDO;
      this.carregandoLancamento = true;
      this.tempoCarregamentoInicio = millis();
    }
  }
  
  //essa funcao comeca no mouseRelease e termina o carregamento da bola. Cria-se um novo tempo de carregamento a partir do this.tempoCarregamentoInicio,
  //escolhe-se a menor entre esse tempo e o tempoMaxCarregamento, e a partir disso calcula-se a razao de carregamento.
  //A velocidade de lancamento é calculada a partir dessa razao e dos valores minimo e maximo de velocidade.
  //Daí, cria o alvo a partir do ponto que vai ser o mouseX, mouseY.
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
      println("velocidade do lancamento: " + this.v);
    }
  }

  //funcao para o carregamento do inimigo. Não há carregamento, portanto é só uma função em que a velocidade e o ângulo vão ser definidos matemáticamente a partir do alvo (minhoca do player)
  //(tenho que trabalhar melhor nisso)
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
  
  //mostra o progresso do carregamento da bola acima da minhoca dona
  void mostrarCarregamento(Minhoca minhocaDona)
  {
    if(b.estado == 1){
    int tempoAtual = millis() - b.tempoCarregamentoInicio;
    float razaoDeCarga = min(tempoAtual, b.tempoMaxCarregamento) / b.tempoMaxCarregamento;
    String texto = nf(razaoDeCarga * 100, 1, 1) + "%";
    text(texto, minhocaDona.p.x, minhocaDona.p.y - 15);
    }
  }

  //cria o ponto alvo a partir do ponto passado, calcula os componentes vx e vy da velocidade a partir do ângulo entre o ponto da bola e o ponto alvo
  void criaAlvo(Ponto p2) {
    this.alvo = p2;
    
    float teta = this.p.angPontos(p2);
    this.vx = this.v * cos(teta);
    this.vy = this.v * sin(teta);
    
    this.foiAtirada = false;
  }
  
  //move a bola se a bola tiver se movendo, coloca a bola dentro da minhoca dona se a minhoca estiver parada
  void processarEstado(Minhoca minhocaDona, Chao chao) {
    switch(estado) {
      case CARREGANDO:
        this.mostrarCarregamento(minhocaDona);
        break;
        
      case EM_MOVIMENTO:
        moveBola(minhocaDona, chao);
        break;
        
      case PARADA:
        // pra bola ficar dentro da minhoca
        this.p.x = minhocaDona.p.x + (minhocaDona.w)/2;
        this.p.y = minhocaDona.p.y + (minhocaDona.h)/2;
        
        break;
    }
  }
  
  //funcao que move a bola, verifica as colisões com a minhoca dona, o chão e as paredes
  void moveBola(Minhoca minhocaDona, Chao chao) {
    // verifica as colisoes da bola
    colisaoParede();
    colisaoBolaChao(chao);
    colisaoMinhoca(minhocaDona);
    
    
    // move a bola em si
    if(movendo && alvo != null) {
      this.p.x += this.vx;
      this.p.y += this.vy;
      this.vx += this.vento;
      this.vy += this.g;
    }
    
    // se a bola saiu da minhoca, marca que foi atirada
    if(!foiAtirada && movendo && minhocaDona != null) {
      if(this.p.y + this.r < minhocaDona.p.y || this.p.y - this.r > minhocaDona.p.y + minhocaDona.h) {
        this.foiAtirada = true;
        println("Bola foi atirada!");
      }
    }
  }
  
  //funcao que verifica a colisao com as paredes da tela
  void colisaoParede() {
    if(this.p.x + this.r >= width || this.p.x - this.r <= 0) {
      this.vx = -this.vx;
    }
    if(this.p.y + this.r >= height || this.p.y - this.r <= 0) {
      this.vy = -this.vy;
    } 
  }

  //funcao que verifica a colisao com o chao
  void colisaoBolaChao(Chao chao){
    float alturaChao = chao.getAlturaChao(this.p.x + this.r/2);
    if(this.p.y + this.r > alturaChao)
    {
      this.reseta(this.p);
    }

  }
  
  //funcao que verifica a colisao com a minhoca passada
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
  
  //funcao que desenha a bola se ela estiver em movimento
  void desenha() {
    if(this.movendo){
    circle(this.p.x, this.p.y, this.r * 2);
    }
  }
  
  //funcao que reseta a bola para o ponto passado, zera as velocidades e marca que a bola nao está mais se movendo
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
