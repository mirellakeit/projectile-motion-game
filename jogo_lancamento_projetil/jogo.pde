// Variáveis globais
int chaoMinimo = 300;
int largura = 1000; //por algum motivo, nao dá só pra usar "width" na função chão
int altura = 600;
int nSeg = largura/100; //número de segmentos do chão

float GRAVIDADE = 0.2;
float VENTO = random(-0.5, 0.5);
float alturaMinhoca = 25, larguraMinhoca = 15;

//cria o chao
Chao chao = new Chao(nSeg, chaoMinimo, largura);

//coloca a minhoca jogável no chao em uma posicao aleatoria nos primeiros 2/5 da tela e a minhoca inimiga nos ultimos 2/5 da tela
float xMinhoca1 = random(larguraMinhoca+10, 2*largura/5);
float xMinhoca2 = random(4*largura/5, largura - larguraMinhoca - 10);

//ajusta a altura das minhocas de acordo com o chao
float chaoMinhoca1 = chao.getAlturaChao(xMinhoca1);
float chaoMinhoca2 = chao.getAlturaChao(xMinhoca2);

//cria o Ponto das minhocas
Ponto pMinhoca = new Ponto(xMinhoca1, chaoMinhoca1 - alturaMinhoca);
Ponto pMinhoca2 = new Ponto(xMinhoca2, chaoMinhoca2 - alturaMinhoca);

//cria as bolas das minhocas
Bola b = new Bola(new Ponto(pMinhoca.x + 10, pMinhoca.y + 20), 8, 5, GRAVIDADE, VENTO);
Bola b2 = new Bola(new Ponto(pMinhoca2.x + 10, pMinhoca2.y + 20), 5, 5, GRAVIDADE, VENTO);

//cria as minhocas em si
Minhoca m = new Minhoca(pMinhoca, b, larguraMinhoca, alturaMinhoca);     // Player
Minhoca m2 = new Minhoca(pMinhoca2, b2, larguraMinhoca, alturaMinhoca); // Enemy

void setup() {
  //por algum motivo, tem que ficar colocando os números mesmo, ao invés de poder usar as variáveis largura e altura.
  size(1000, 600);

}

void draw() {
  // Desenha o fundo
  background(200);

  //desenha o chao
  chao.desenhaChao(nSeg);

  // Atualiza e desenha o jogador. (a função atualizar move, verifica colisões e atira a bola)
  m.atualizar(chao);
  m.desenha();
  
  // Atualiza e desenha inimigo
  m2.desenha();
  m2.atualizarInimigo(chao);
  
  // Desenha as bolas
  b.desenha();
  b2.desenha();

  //checa a colisao das bolas com as minhocas
  b.colisaoMinhoca(m2);
  b2.colisaoMinhoca(m);

  fill(0);
  text("bola do player: " + b.getEstadoNome(), 10, 20);
  text("bola do inimigo: " + b2.getEstadoNome(), 10, 40);
  fill(50);
  text("Vento: " + VENTO, 10, 60);
  fill(0);
}

void mousePressed() {
  b.comecaCarregamento();
}

void mouseReleased() {
  b.terminaCarregamento(new Ponto(mouseX, mouseY));
}

void keyPressed() {
  if(keyCode == 'R' || keyCode == 'r') {
    //reseta as bolas para dentro das minhocas
    b.reseta(new Ponto(m.p.x + m.w/2, m.p.y + m.h/2));
    b2.reseta(new Ponto(m2.p.x + m2.w/2, m2.p.y + m2.h/2));
    println("Bolas resetadas!");
  }

  if(keyCode == 'L' || keyCode == 'l') {
    //faz o inimigo lançar a bola
    m2.lancamentoInimigo(b2,m);
  }
  
  if(keyCode == 'C' || keyCode == 'c') {
    //cria um novo chao e adequa as posições das minhocas a ele
    chao = new Chao(nSeg, chaoMinimo, largura);

    xMinhoca1 = random(larguraMinhoca, 2*largura/5);
    xMinhoca2 = random(largura/2 + 10, largura - larguraMinhoca - 10);

    chaoMinhoca1 = chao.getAlturaChao(xMinhoca1);
    chaoMinhoca2 = chao.getAlturaChao(xMinhoca2);

    pMinhoca = new Ponto(xMinhoca1, chaoMinhoca1 - alturaMinhoca);
    pMinhoca2 = new Ponto(xMinhoca2, chaoMinhoca2 - alturaMinhoca);

    b = new Bola(new Ponto(pMinhoca.x + 10, pMinhoca.y + 20), 8, 5, GRAVIDADE, VENTO);
    b2 = new Bola(new Ponto(pMinhoca2.x + 10, pMinhoca2.y + 20), 5, 5, GRAVIDADE, VENTO);

    m = new Minhoca(pMinhoca, b, larguraMinhoca, alturaMinhoca);     // Player
    m2 = new Minhoca(pMinhoca2, b2, larguraMinhoca, alturaMinhoca);
    println("xMinhoca2 = ", xMinhoca2);
  }

  if(keyCode == 'V' || keyCode == 'v') {
    //muda o vento
    VENTO = random(-0.05, 0.05);
    b.vento = VENTO;
    b2.vento = VENTO;
  }
}
