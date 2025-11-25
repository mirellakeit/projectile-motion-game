// Variáveis globais
Ponto pMinhoca = new Ponto(150, 200);
Ponto pMinhoca2 = new Ponto(250, 100);

Bola b = new Bola(new Ponto(pMinhoca.x + 10, pMinhoca.y + 20), 8, 10, 0.2);
Bola b2 = new Bola(new Ponto(pMinhoca2.x + 10, pMinhoca2.y + 20), 5, 10, 0.2);

Minhoca m = new Minhoca(pMinhoca, b);     // Player
Minhoca m2 = new Minhoca(pMinhoca2, b2); // Enemy

void setup() {
  size(400, 400);
  println("Controles:");
  println("- Mouse: Pressione e segure para carregar, solte para lançar");
  println("- SETAS: Movimentar player");
  println("- R: Resetar bolas");
  println("- L: Lançamento rápido do inimigo");
}

void draw() {
  background(200);
  
  // Atualiza e desenha player
  m.atualizar();
  m.desenha();
  
  // Atualiza e desenha inimigo
  //m2.atualizar();
  m2.desenha();
  
  // Desenha as bolas (agora desenhadas pela própria bola)
  b.desenha();
  b2.desenha();

  b.colisaoMinhoca(m2);
  
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
