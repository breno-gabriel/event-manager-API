# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Limpando dados existentes..."
Participant.destroy_all
CheckinRule.destroy_all
Event.destroy_all
User.destroy_all

# ──────────────────────────────────────
# Usuários
# ──────────────────────────────────────
puts "Criando usuários..."

admin = User.create!(
  name: "Admin",
  email: "admin@eventmanager.com",
  password: "password123"
)

maria = User.create!(
  name: "Maria Silva",
  email: "maria@example.com",
  password: "password123"
)

joao = User.create!(
  name: "João Santos",
  email: "joao@example.com",
  password: "password123"
)

puts "  ✔ #{User.count} usuários criados"

# ──────────────────────────────────────
# Eventos
# ──────────────────────────────────────
puts "Criando eventos..."

conferencia = Event.create!(
  name: "Conferência de Tecnologia 2026",
  description: "A maior conferência de tecnologia do ano, com palestras sobre IA, Cloud e DevOps.",
  date: DateTime.new(2026, 6, 15, 9, 0, 0),
  location: "Centro de Convenções - São Paulo, SP",
  status: 1,
  checkin_rules_attributes: [
    { name: "Check-in Principal", start_minutes: 0, end_minutes: 60, is_active: true, is_mandatory: true },
    { name: "Check-in VIP Antecipado", start_minutes: 0, end_minutes: 30, is_active: true, is_mandatory: false }
  ]
)

workshop = Event.create!(
  name: "Workshop de Ruby on Rails",
  description: "Workshop prático de desenvolvimento de APIs com Ruby on Rails 8.",
  date: DateTime.new(2026, 7, 20, 14, 0, 0),
  location: "Espaço Coworking Tech - Rio de Janeiro, RJ",
  status: 1,
  checkin_rules_attributes: [
    { name: "Check-in Entrada", start_minutes: 0, end_minutes: 30, is_active: true, is_mandatory: true },
    { name: "Check-in Intervalo", start_minutes: 120, end_minutes: 150, is_active: true, is_mandatory: false },
    { name: "Check-in Saída", start_minutes: 240, end_minutes: 270, is_active: true, is_mandatory: false }
  ]
)

meetup = Event.create!(
  name: "Meetup de Desenvolvedores",
  description: "Encontro mensal da comunidade de desenvolvedores para networking e troca de experiências.",
  date: DateTime.new(2026, 4, 10, 19, 0, 0),
  location: "Pub Dev House - Belo Horizonte, MG",
  status: 1,
  checkin_rules_attributes: [
    { name: "Check-in Livre", start_minutes: 0, end_minutes: 120, is_active: true, is_mandatory: true },
    { name: "Check-in Networking", start_minutes: 60, end_minutes: 120, is_active: true, is_mandatory: false }
  ]
)

hackathon = Event.create!(
  name: "Hackathon Sustentabilidade",
  description: "48 horas de desenvolvimento de soluções tecnológicas para problemas ambientais.",
  date: DateTime.new(2026, 9, 5, 8, 0, 0),
  location: "Campus Universitário - Curitiba, PR",
  status: 0,
  checkin_rules_attributes: [
    { name: "Check-in Credenciamento", start_minutes: 0, end_minutes: 60, is_active: true, is_mandatory: true },
    { name: "Check-in Abertura", start_minutes: 30, end_minutes: 60, is_active: true, is_mandatory: false }
  ]
)

evento_encerrado = Event.create!(
  name: "Palestra: Futuro da IA",
  description: "Palestra sobre os avanços recentes em inteligência artificial generativa.",
  date: DateTime.new(2026, 1, 20, 18, 0, 0),
  location: "Auditório Central - Porto Alegre, RS",
  status: 2,
  checkin_rules_attributes: [
    { name: "Check-in Palestra", start_minutes: 0, end_minutes: 30, is_active: true, is_mandatory: true },
    { name: "Check-in Coffee Break", start_minutes: 60, end_minutes: 90, is_active: false, is_mandatory: false }
  ]
)

summit = Event.create!(
  name: "Summit de Startups Brasil",
  description: "O maior encontro de startups e investidores do país. Pitches, mentorias e rodadas de investimento.",
  date: DateTime.new(2026, 8, 22, 8, 30, 0),
  location: "Centro de Inovação - Florianópolis, SC",
  status: 1,
  checkin_rules_attributes: [
    { name: "Check-in Geral", start_minutes: 0, end_minutes: 45, is_active: true, is_mandatory: true },
    { name: "Check-in Pitch Session", start_minutes: 90, end_minutes: 120, is_active: true, is_mandatory: false },
    { name: "Check-in Rodada de Investimento", start_minutes: 180, end_minutes: 210, is_active: true, is_mandatory: false }
  ]
)

bootcamp = Event.create!(
  name: "Bootcamp Full Stack",
  description: "Imersão intensiva de 3 dias em desenvolvimento Full Stack com React e Node.js.",
  date: DateTime.new(2026, 5, 11, 8, 0, 0),
  location: "Hub de Tecnologia - Recife, PE",
  status: 1,
  checkin_rules_attributes: [
    { name: "Check-in Matutino", start_minutes: 0, end_minutes: 30, is_active: true, is_mandatory: true },
    { name: "Check-in Vespertino", start_minutes: 240, end_minutes: 270, is_active: true, is_mandatory: false }
  ]
)

feira = Event.create!(
  name: "Feira de Carreiras em TI",
  description: "Feira de recrutamento com as principais empresas de tecnologia do mercado.",
  date: DateTime.new(2026, 10, 3, 10, 0, 0),
  location: "Pavilhão de Exposições - Brasília, DF",
  status: 0,
  checkin_rules_attributes: [
    { name: "Check-in Entrada Principal", start_minutes: 0, end_minutes: 60, is_active: true, is_mandatory: true },
    { name: "Check-in Área de Palestras", start_minutes: 30, end_minutes: 60, is_active: true, is_mandatory: false },
    { name: "Check-in Speed Interview", start_minutes: 120, end_minutes: 150, is_active: true, is_mandatory: false }
  ]
)

devops_day = Event.create!(
  name: "DevOps Day 2026",
  description: "Dia inteiro dedicado a práticas de DevOps, CI/CD, Kubernetes e observabilidade.",
  date: DateTime.new(2026, 11, 14, 9, 0, 0),
  location: "Teatro Municipal Tech - Salvador, BA",
  status: 0,
  checkin_rules_attributes: [
    { name: "Check-in Manhã", start_minutes: 0, end_minutes: 30, is_active: true, is_mandatory: true },
    { name: "Check-in Hands-on Lab", start_minutes: 150, end_minutes: 180, is_active: true, is_mandatory: false }
  ]
)

webinar = Event.create!(
  name: "Webinar: Segurança em APIs",
  description: "Sessão online sobre boas práticas de segurança em APIs REST e GraphQL.",
  date: DateTime.new(2026, 3, 25, 19, 0, 0),
  location: "Online - Zoom",
  status: 2,
  checkin_rules_attributes: [
    { name: "Check-in Online", start_minutes: 0, end_minutes: 15, is_active: true, is_mandatory: true },
    { name: "Check-in Q&A", start_minutes: 50, end_minutes: 60, is_active: true, is_mandatory: false }
  ]
)

puts "  ✔ #{Event.count} eventos criados"
puts "  ✔ #{CheckinRule.count} regras de check-in criadas"

# ──────────────────────────────────────
# Participantes
# ──────────────────────────────────────
puts "Criando participantes..."

# Conferência de Tecnologia
Participant.create!(name: "Ana Costa", email: "ana.costa@example.com", event: conferencia, check_in_status: true)
Participant.create!(name: "Carlos Oliveira", email: "carlos.oliveira@example.com", event: conferencia, check_in_status: true)
Participant.create!(name: "Fernanda Lima", email: "fernanda.lima@example.com", event: conferencia, check_in_status: false)
Participant.create!(name: "Rafael Mendes", email: "rafael.mendes@example.com", event: conferencia, check_in_status: false)
Participant.create!(name: "Juliana Pereira", email: "juliana.pereira@example.com", event: conferencia, check_in_status: true)
Participant.create!(name: "Roberto Gomes", email: "roberto.gomes@example.com", event: conferencia, check_in_status: false)
Participant.create!(name: "Patrícia Nunes", email: "patricia.nunes@example.com", event: conferencia, check_in_status: true)

# Workshop de Ruby on Rails
Participant.create!(name: "Lucas Ferreira", email: "lucas.ferreira@example.com", event: workshop, check_in_status: true)
Participant.create!(name: "Beatriz Souza", email: "beatriz.souza@example.com", event: workshop, check_in_status: false)
Participant.create!(name: "Pedro Almeida", email: "pedro.almeida@example.com", event: workshop, check_in_status: true)
Participant.create!(name: "Larissa Cardoso", email: "larissa.cardoso@example.com", event: workshop, check_in_status: true)
Participant.create!(name: "Gustavo Pinto", email: "gustavo.pinto@example.com", event: workshop, check_in_status: false)

# Meetup de Desenvolvedores
Participant.create!(name: "Mariana Rocha", email: "mariana.rocha@example.com", event: meetup, check_in_status: true)
Participant.create!(name: "Thiago Santos", email: "thiago.santos@example.com", event: meetup, check_in_status: true)
Participant.create!(name: "Camila Dias", email: "camila.dias@example.com", event: meetup, check_in_status: false)
Participant.create!(name: "Bruno Martins", email: "bruno.martins@example.com", event: meetup, check_in_status: true)
Participant.create!(name: "Renata Vieira", email: "renata.vieira@example.com", event: meetup, check_in_status: true)

# Hackathon Sustentabilidade
Participant.create!(name: "Felipe Araújo", email: "felipe.araujo@example.com", event: hackathon, check_in_status: false)
Participant.create!(name: "Amanda Torres", email: "amanda.torres@example.com", event: hackathon, check_in_status: false)
Participant.create!(name: "Vinícius Lopes", email: "vinicius.lopes@example.com", event: hackathon, check_in_status: false)
Participant.create!(name: "Natália Barbosa", email: "natalia.barbosa@example.com", event: hackathon, check_in_status: false)

# Palestra: Futuro da IA (encerrado)
Participant.create!(name: "Isabela Nascimento", email: "isabela.nascimento@example.com", event: evento_encerrado, check_in_status: true)
Participant.create!(name: "Diego Ribeiro", email: "diego.ribeiro@example.com", event: evento_encerrado, check_in_status: true)
Participant.create!(name: "Aline Moreira", email: "aline.moreira@example.com", event: evento_encerrado, check_in_status: true)

# Summit de Startups Brasil
Participant.create!(name: "Gabriel Correia", email: "gabriel.correia@example.com", event: summit, check_in_status: true)
Participant.create!(name: "Tatiana Fonseca", email: "tatiana.fonseca@example.com", event: summit, check_in_status: false)
Participant.create!(name: "André Cavalcanti", email: "andre.cavalcanti@example.com", event: summit, check_in_status: true)
Participant.create!(name: "Carolina Duarte", email: "carolina.duarte@example.com", event: summit, check_in_status: false)
Participant.create!(name: "Marcelo Teixeira", email: "marcelo.teixeira@example.com", event: summit, check_in_status: true)
Participant.create!(name: "Daniela Cunha", email: "daniela.cunha@example.com", event: summit, check_in_status: false)

# Bootcamp Full Stack
Participant.create!(name: "Luana Freitas", email: "luana.freitas@example.com", event: bootcamp, check_in_status: true)
Participant.create!(name: "Igor Rezende", email: "igor.rezende@example.com", event: bootcamp, check_in_status: true)
Participant.create!(name: "Sabrina Campos", email: "sabrina.campos@example.com", event: bootcamp, check_in_status: false)
Participant.create!(name: "Henrique Monteiro", email: "henrique.monteiro@example.com", event: bootcamp, check_in_status: true)

# Feira de Carreiras em TI
Participant.create!(name: "Vanessa Ramos", email: "vanessa.ramos@example.com", event: feira, check_in_status: false)
Participant.create!(name: "Rodrigo Assis", email: "rodrigo.assis@example.com", event: feira, check_in_status: false)
Participant.create!(name: "Priscila Moura", email: "priscila.moura@example.com", event: feira, check_in_status: false)
Participant.create!(name: "Fábio Carvalho", email: "fabio.carvalho@example.com", event: feira, check_in_status: false)
Participant.create!(name: "Simone Azevedo", email: "simone.azevedo@example.com", event: feira, check_in_status: false)

# DevOps Day 2026
Participant.create!(name: "Eduardo Prado", email: "eduardo.prado@example.com", event: devops_day, check_in_status: false)
Participant.create!(name: "Michele Barros", email: "michele.barros@example.com", event: devops_day, check_in_status: false)
Participant.create!(name: "Alexandre Machado", email: "alexandre.machado@example.com", event: devops_day, check_in_status: false)

# Webinar: Segurança em APIs (encerrado)
Participant.create!(name: "Cristiane Borges", email: "cristiane.borges@example.com", event: webinar, check_in_status: true)
Participant.create!(name: "Otávio Rangel", email: "otavio.rangel@example.com", event: webinar, check_in_status: true)
Participant.create!(name: "Débora Sampaio", email: "debora.sampaio@example.com", event: webinar, check_in_status: false)

puts "  ✔ #{Participant.count} participantes criados"

puts ""
puts "Seed concluído com sucesso!"
puts "  → #{User.count} usuários"
puts "  → #{Event.count} eventos"
puts "  → #{CheckinRule.count} regras de check-in"
puts "  → #{Participant.count} participantes"
