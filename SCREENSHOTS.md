# 📸 CAPTURAS DE TELA - CRM IMOBILIÁRIO

## 🎨 Interface Flutter Web (Dark Mode)

### 1. Dashboard Principal
- Visão geral do sistema
- Cards de estatísticas
- Ações rápidas (Nova Pessoa, Nova Imobiliária)
- Navegação lateral (Sidebar)

### 2. Cadastro de Pessoa - Step 1 (Dados Básicos)
- Seleção de tipo (PF/PJ)
- Nome completo / Razão Social
- Email
- CPF/CNPJ com máscara
- RG (apenas PF)
- Telefone e Celular com máscaras
- Papel no sistema (dropdown)

### 3. Cadastro de Pessoa - Step 2 (Endereço)
- CEP com máscara
- Rua
- Número e Complemento
- Bairro
- Cidade e Estado (UF)

### 3. Cadastro de Pessoa - Step 3 (Informações Adicionais)
- Observações (textarea)
- Aviso de revisão
- Botões: Voltar e Salvar

### 4. Cadastro de Imobiliária - Step 1 (Dados Básicos)
- Razão Social
- Nome Fantasia
- CNPJ com máscara
- Email
- CRECI

### 5. Cadastro de Imobiliária - Step 2 (Endereço e Contato)
- Telefone
- Website
- Endereço completo (igual pessoa)

### 6. Cadastro de Imobiliária - Step 3 (Plano)
- Seleção de plano (cards):
  - Básico (ícone foguete)
  - Profissional (ícone gráfico)
  - Enterprise (ícone maleta)
- Observações
- Aviso de revisão

### 7. Lista de Pessoas (Empty State)
- Ícone grande de pessoas
- Mensagem "Nenhuma pessoa cadastrada"
- Botão "Cadastrar Primeira Pessoa"

### 8. Lista de Imobiliárias (Empty State)
- Ícone grande de empresa
- Mensagem "Nenhuma imobiliária cadastrada"
- Botão "Cadastrar Primeira Imobiliária"

## 🎨 Paleta de Cores

### Cores Principais
- **Primary (Indigo):** #6366F1
- **Secondary (Purple):** #8B5CF6
- **Accent (Green):** #10B981
- **Error (Red):** #EF4444

### Background (Dark)
- **Background:** #0F172A (Slate 900)
- **Surface:** #1E293B (Slate 800)
- **Card:** #334155 (Slate 700)

### Texto
- **Primary:** #F1F5F9 (Slate 100)
- **Secondary:** #94A3B8 (Slate 400)
- **Disabled:** #475569 (Slate 600)

## 🖼️ Componentes Visuais

### Cards
- Border radius: 16px
- Borda sutil com opacity 0.3
- Padding: 24px
- Hover effect com transição suave

### Botões
- Primary: Fundo Indigo, texto branco
- Outlined: Borda Indigo, texto Indigo
- Text: Apenas texto Indigo
- Border radius: 12px
- Padding: 16px horizontal, 12px vertical

### Inputs
- Fundo: Surface color
- Borda: Card color (normal), Primary (focus)
- Border radius: 12px
- Padding: 16px
- Label flutuante
- Ícones à esquerda

### Stepper
- Indicador de progresso
- Números dos steps
- Linha conectora
- Cores: Primary (ativo), Secondary (completo), Disabled (inativo)

## 📱 Responsividade

- Desktop: Layout com sidebar
- Tablet: Sidebar colapsável
- Mobile: Bottom navigation (futuro)

## ✨ Animações

- Transições suaves (200-300ms)
- Hover effects nos cards
- Focus states nos inputs
- Loading states (spinners)
- Toast notifications

## 🎯 UX Highlights

- Validação em tempo real
- Feedback visual imediato
- Mensagens de erro claras
- Máscaras automáticas
- Auto-save (draft) - futuro
- Progress bar no stepper
- Empty states informativos
- Ações rápidas no dashboard

---

**Nota:** Para ver as telas em ação, execute o frontend Flutter Web:

```bash
cd frontend
flutter run -d chrome
```
