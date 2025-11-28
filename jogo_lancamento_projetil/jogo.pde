// Variáveis globais
int chaoMinimo = 300;
int largura = 1000; //por algum motivo, nao dá só pra usar "width" na função chão
int altura = 600;
int nSeg = largura/100;

float GRAVIDADE = 0.2;
float VENTO = -0.1;
float alturaMinhoca = 25, larguraMinhoca = 15;

Chao chao = new Chao(nSeg, chaoMinimo, largura);

float chaoMinhoca1 = chao.getAlturaChao(20);
float chaoMinhoca2 = chao.getAlturaChao(520);

Ponto pMinhoca = new Ponto(20, chaoMinhoca1 - alturaMinhoca);
Ponto pMinhoca2 = new Ponto(520, chaoMinhoca2 - alturaMinhoca);

Bola b = new Bola(new Ponto(pMinhoca.x + 10, pMinhoca.y + 20), 8, 5, GRAVIDADE, VENTO);
Bola b2 = new Bola(new Ponto(pMinhoca2.x + 10, pMinhoca2.y + 20), 5, 5, GRAVIDADE, VENTO);

Minhoca m = new Minhoca(pMinhoca, b, larguraMinhoca, alturaMinhoca);     // Player
Minhoca m2 = new Minhoca(pMinhoca2, b2, larguraMinhoca, alturaMinhoca); // Enemy

void setup() {
  //println(alturaInicialChao);

  size(800, 600);
  //chao.desenhaChao(nSeg);

 
  //println(nSeg);
  //println(chao.segmentosChaoY);
  for(int i = 0; i < nSeg - 1; i++){
  //println("segmento[" + i + "] = " + chao.segmentosChaoY[i] + " ; segmento [" + i + 1 + "] = " + chao.segmentosChaoY[i+i]);
  }
}

void draw() {
  background(200);
  chao.desenhaChao(nSeg);
  // Atualiza e desenha player
  m.atualizar(chao);
  m.mostrarCarregamento(b);
  m.desenha();
  
  // Atualiza e desenha inimigo
  //m2.atualizar();
  m2.desenha();
  
  // Desenha as bolas (agora desenhadas pela própria bola)
  b.desenha();
  b2.desenha();

  //b.colisaoMinhoca(m2);
  
  // Info de debug
  fill(0);
  text("Player Estado: " + b.getEstadoNome(), 10, 20);
  text("Inimigo Estado: " + b2.getEstadoNome(), 10, 40);
}

void mousePressed() {
  b.comecaCarregamento();
}

void mouseReleased() {
  b.terminaCarregamento(new Ponto(mouseX, mouseY));
}

void keyPressed() {
  if(keyCode == 'R' || keyCode == 'r') {
    b.reseta(new Ponto(m.p.x + m.w/2, m.p.y + m.h/2));
    b2.reseta(new Ponto(m2.p.x + m2.w/2, m2.p.y + m2.h/2));
    println("Bolas resetadas!");
  }

  if(keyCode == 'L' || keyCode == 'l') {
    // Lançamento rápido do inimigo
    b2.criaAlvo(new Ponto(mouseX, mouseY));
    b2.estado = b2.EM_MOVIMENTO;
    b2.movendo = true;
    b2.foiAtirada = true;
    println("Inimigo atirou!");
  }
}
