import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/company.dart';
import '../../services/company_service.dart';
import '../../services/brasilapi_service.dart';
import '../../theme/app_theme.dart';

class CompanyFormScreen extends StatefulWidget {
  final Company? company; // Para edição

  const CompanyFormScreen({super.key, this.company});

  @override
  State<CompanyFormScreen> createState() => _CompanyFormScreenState();
}

class _CompanyFormScreenState extends State<CompanyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyService = CompanyService();
  final _brasilAPIService = BrasilAPIService();
  
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final _companyNameController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _creciController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _notesController = TextEditingController();

  // Máscaras
  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String _planType = 'basic';

  @override
  void initState() {
    super.initState();
    if (widget.company != null) {
      _loadCompany(widget.company!);
    }
  }

  void _loadCompany(Company company) {
    _companyNameController.text = company.companyName;
    _tradeNameController.text = company.tradeName;
    _cnpjController.text = company.cnpj;
    _emailController.text = company.email;
    _phoneController.text = company.phone ?? '';
    _websiteController.text = company.website ?? '';
    _creciController.text = company.creci ?? '';
    _streetController.text = company.addressStreet ?? '';
    _numberController.text = company.addressNumber ?? '';
    _complementController.text = company.addressComplement ?? '';
    _neighborhoodController.text = company.addressNeighborhood ?? '';
    _cityController.text = company.addressCity ?? '';
    _stateController.text = company.addressState ?? '';
    _zipcodeController.text = company.addressZipcode ?? '';
    _notesController.text = company.notes ?? '';
    _planType = company.planType;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _tradeNameController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _creciController.dispose();
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

  Future<void> _saveCompany() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final company = Company(
        id: widget.company?.id,
        companyName: _companyNameController.text,
        tradeName: _tradeNameController.text,
        cnpj: _cnpjController.text.replaceAll(RegExp(r'[^\d]'), ''),
        email: _emailController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        website: _websiteController.text.isEmpty ? null : _websiteController.text,
        creci: _creciController.text.isEmpty ? null : _creciController.text,
        addressStreet: _streetController.text.isEmpty ? null : _streetController.text,
        addressNumber: _numberController.text.isEmpty ? null : _numberController.text,
        addressComplement: _complementController.text.isEmpty ? null : _complementController.text,
        addressNeighborhood: _neighborhoodController.text.isEmpty ? null : _neighborhoodController.text,
        addressCity: _cityController.text.isEmpty ? null : _cityController.text,
        addressState: _stateController.text.isEmpty ? null : _stateController.text,
        addressZipcode: _zipcodeController.text.isEmpty ? null : _zipcodeController.text.replaceAll(RegExp(r'[^\d]'), ''),
        planType: _planType,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await _companyService.createCompany(company);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imobiliária cadastrada com sucesso!'),
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
        title: Text(widget.company == null ? 'Nova Imobiliária' : 'Editar Imobiliária'),
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
              _saveCompany();
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
            // Step 2: Endereço e Contato
            Step(
              title: const Text('Endereço e Contato'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildStep2(),
            ),
            // Step 3: Plano e Informações Adicionais
            Step(
              title: const Text('Plano e Informações'),
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
      children: [
        // Razão Social
        TextFormField(
          controller: _companyNameController,
          decoration: const InputDecoration(
            labelText: 'Razão Social',
            prefixIcon: Icon(Icons.business_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Nome Fantasia
        TextFormField(
          controller: _tradeNameController,
          decoration: const InputDecoration(
            labelText: 'Nome Fantasia',
            prefixIcon: Icon(Icons.store_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // CNPJ com botão de busca
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(
                  labelText: 'CNPJ',
                  prefixIcon: Icon(Icons.badge_outlined),
                  hintText: '00.000.000/0000-00',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [_cnpjMask],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (value.length < 18) {
                    return 'CNPJ inválido';
                  }
                  if (!BrasilAPIService.validarCNPJLocal(value)) {
                    return 'CNPJ inválido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _buscarDadosCNPJ,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.search, size: 20),
              label: const Text('Buscar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ],
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

        // CRECI
        TextFormField(
          controller: _creciController,
          decoration: const InputDecoration(
            labelText: 'CRECI',
            prefixIcon: Icon(Icons.verified_outlined),
            hintText: 'Ex: CRECI-SP 12345',
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
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

        // Website
        TextFormField(
          controller: _websiteController,
          decoration: const InputDecoration(
            labelText: 'Website',
            prefixIcon: Icon(Icons.language_outlined),
            hintText: 'https://www.exemplo.com.br',
          ),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 24),

        Divider(color: AppTheme.cardColor),
        const SizedBox(height: 24),

        // CEP com botão de busca
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _zipcodeController,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: '00000-000',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [_cepMask],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _buscarEnderecoCEP,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.search, size: 20),
              label: const Text('Buscar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Plano Contratado', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        
        // Planos
        _buildPlanCard(
          'basic',
          'Básico',
          'Ideal para começar',
          Icons.rocket_launch_outlined,
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          'professional',
          'Profissional',
          'Para imobiliárias em crescimento',
          Icons.trending_up_outlined,
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          'enterprise',
          'Enterprise',
          'Solução completa para grandes operações',
          Icons.business_center_outlined,
        ),
        const SizedBox(height: 24),

        // Observações
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Observações',
            prefixIcon: Icon(Icons.notes_outlined),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
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

  /// Busca dados da empresa pelo CNPJ
  Future<void> _buscarDadosCNPJ() async {
    final cnpj = _cnpjController.text;
    
    if (cnpj.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o CNPJ primeiro'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    // Valida CNPJ localmente
    if (!BrasilAPIService.validarCNPJLocal(cnpj)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CNPJ inválido'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final dados = await _brasilAPIService.buscarCNPJ(cnpj);
      
      // Preencher campos automaticamente
      _companyNameController.text = dados['company_name'] ?? '';
      _tradeNameController.text = dados['trade_name'] ?? '';
      _emailController.text = dados['email'] ?? '';
      _phoneController.text = dados['phone'] ?? '';
      _streetController.text = dados['address_street'] ?? '';
      _numberController.text = dados['address_number'] ?? '';
      _complementController.text = dados['address_complement'] ?? '';
      _neighborhoodController.text = dados['address_neighborhood'] ?? '';
      _cityController.text = dados['address_city'] ?? '';
      _stateController.text = dados['address_state'] ?? '';
      _zipcodeController.text = dados['address_zipcode'] ?? '';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Dados preenchidos automaticamente!'),
            backgroundColor: AppTheme.accentColor,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  /// Busca endereço pelo CEP
  Future<void> _buscarEnderecoCEP() async {
    final cep = _zipcodeController.text;
    
    if (cep.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o CEP primeiro'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final dados = await _brasilAPIService.buscarCEP(cep);
      
      // Preencher campos de endereço
      _streetController.text = dados['street'] ?? '';
      _neighborhoodController.text = dados['neighborhood'] ?? '';
      _cityController.text = dados['city'] ?? '';
      _stateController.text = dados['state'] ?? '';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Endereço preenchido automaticamente!'),
            backgroundColor: AppTheme.accentColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildPlanCard(String value, String title, String subtitle, IconData icon) {
    final isSelected = _planType == value;
    return InkWell(
      onTap: () => setState(() => _planType = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}
