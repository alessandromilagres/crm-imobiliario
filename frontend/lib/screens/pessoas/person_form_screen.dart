import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/person.dart';
import '../../services/person_service.dart';
import '../../theme/app_theme.dart';

class PersonFormScreen extends StatefulWidget {
  final Person? person; // Para edição

  const PersonFormScreen({super.key, this.person});

  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _personService = PersonService();
  
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _rgController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _notesController = TextEditingController();

  // Máscaras
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _mobileMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String _personType = 'PF';
  String _role = 'cliente';

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _loadPerson(widget.person!);
    }
  }

  void _loadPerson(Person person) {
    _nameController.text = person.name;
    _emailController.text = person.email;
    _phoneController.text = person.phone ?? '';
    _mobileController.text = person.mobile ?? '';
    _cpfController.text = person.cpf ?? '';
    _cnpjController.text = person.cnpj ?? '';
    _rgController.text = person.rg ?? '';
    _streetController.text = person.addressStreet ?? '';
    _numberController.text = person.addressNumber ?? '';
    _complementController.text = person.addressComplement ?? '';
    _neighborhoodController.text = person.addressNeighborhood ?? '';
    _cityController.text = person.addressCity ?? '';
    _stateController.text = person.addressState ?? '';
    _zipcodeController.text = person.addressZipcode ?? '';
    _notesController.text = person.notes ?? '';
    _personType = person.personType;
    _role = person.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _cpfController.dispose();
    _cnpjController.dispose();
    _rgController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePerson() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final person = Person(
        id: widget.person?.id,
        personType: _personType,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        mobile: _mobileController.text.isEmpty ? null : _mobileController.text,
        cpf: _cpfController.text.isEmpty ? null : _cpfController.text.replaceAll(RegExp(r'[^\d]'), ''),
        cnpj: _cnpjController.text.isEmpty ? null : _cnpjController.text.replaceAll(RegExp(r'[^\d]'), ''),
        rg: _rgController.text.isEmpty ? null : _rgController.text,
        addressStreet: _streetController.text.isEmpty ? null : _streetController.text,
        addressNumber: _numberController.text.isEmpty ? null : _numberController.text,
        addressComplement: _complementController.text.isEmpty ? null : _complementController.text,
        addressNeighborhood: _neighborhoodController.text.isEmpty ? null : _neighborhoodController.text,
        addressCity: _cityController.text.isEmpty ? null : _cityController.text,
        addressState: _stateController.text.isEmpty ? null : _stateController.text,
        addressZipcode: _zipcodeController.text.isEmpty ? null : _zipcodeController.text.replaceAll(RegExp(r'[^\d]'), ''),
        role: _role,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await _personService.createPerson(person);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pessoa cadastrada com sucesso!'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person == null ? 'Nova Pessoa' : 'Editar Pessoa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _savePerson();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Salvar' : 'Próximo'),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: _isLoading ? null : details.onStepCancel,
                      child: const Text('Voltar'),
                    ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Dados Básicos
            Step(
              title: const Text('Dados Básicos'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _buildStep1(),
            ),
            // Step 2: Endereço
            Step(
              title: const Text('Endereço'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildStep2(),
            ),
            // Step 3: Informações Adicionais
            Step(
              title: const Text('Informações Adicionais'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _buildStep3(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tipo de Pessoa
        Text('Tipo de Pessoa', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'PF', label: Text('Pessoa Física'), icon: Icon(Icons.person)),
            ButtonSegment(value: 'PJ', label: Text('Pessoa Jurídica'), icon: Icon(Icons.business)),
          ],
          selected: {_personType},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() => _personType = newSelection.first);
          },
        ),
        const SizedBox(height: 24),

        // Nome
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: _personType == 'PF' ? 'Nome Completo' : 'Razão Social',
            prefixIcon: const Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            if (!value.contains('@')) {
              return 'Email inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // CPF ou CNPJ
        if (_personType == 'PF')
          TextFormField(
            controller: _cpfController,
            decoration: const InputDecoration(
              labelText: 'CPF',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [_cpfMask],
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 14) {
                return 'CPF inválido';
              }
              return null;
            },
          )
        else
          TextFormField(
            controller: _cnpjController,
            decoration: const InputDecoration(
              labelText: 'CNPJ',
              prefixIcon: Icon(Icons.business_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [_cnpjMask],
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 18) {
                return 'CNPJ inválido';
              }
              return null;
            },
          ),
        const SizedBox(height: 16),

        // RG (só para PF)
        if (_personType == 'PF')
          TextFormField(
            controller: _rgController,
            decoration: const InputDecoration(
              labelText: 'RG',
              prefixIcon: Icon(Icons.credit_card_outlined),
            ),
          ),
        const SizedBox(height: 16),

        // Telefone
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Telefone',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [_phoneMask],
        ),
        const SizedBox(height: 16),

        // Celular
        TextFormField(
          controller: _mobileController,
          decoration: const InputDecoration(
            labelText: 'Celular',
            prefixIcon: Icon(Icons.smartphone_outlined),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [_mobileMask],
        ),
        const SizedBox(height: 16),

        // Papel
        DropdownButtonFormField<String>(
          value: _role,
          decoration: const InputDecoration(
            labelText: 'Papel no Sistema',
            prefixIcon: Icon(Icons.work_outline),
          ),
          items: const [
            DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
            DropdownMenuItem(value: 'corretor', child: Text('Corretor')),
            DropdownMenuItem(value: 'vendedor', child: Text('Vendedor')),
            DropdownMenuItem(value: 'gestor', child: Text('Gestor')),
            DropdownMenuItem(value: 'admin', child: Text('Administrador')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _role = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        // CEP
        TextFormField(
          controller: _zipcodeController,
          decoration: const InputDecoration(
            labelText: 'CEP',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [_cepMask],
        ),
        const SizedBox(height: 16),

        // Rua
        TextFormField(
          controller: _streetController,
          decoration: const InputDecoration(
            labelText: 'Rua',
            prefixIcon: Icon(Icons.map_outlined),
          ),
        ),
        const SizedBox(height: 16),

        // Número e Complemento
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Número',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _complementController,
                decoration: const InputDecoration(
                  labelText: 'Complemento',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Bairro
        TextFormField(
          controller: _neighborhoodController,
          decoration: const InputDecoration(
            labelText: 'Bairro',
            prefixIcon: Icon(Icons.location_city_outlined),
          ),
        ),
        const SizedBox(height: 16),

        // Cidade e Estado
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'UF',
                ),
                maxLength: 2,
                textCapitalization: TextCapitalization.characters,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Observações',
            prefixIcon: Icon(Icons.notes_outlined),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Revise os dados antes de salvar. Você poderá editá-los depois.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
