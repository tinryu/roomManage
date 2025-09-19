import 'package:app_project/utils/localization_manager.dart';
import 'package:app_project/widgets/shared/base_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_project/models/payment.dart';
import 'package:app_project/providers/payment_provider.dart';

class AddPaymentScreen extends BaseAddScreen<Payment> {
  AddPaymentScreen({super.key, super.initialItem})
    : super(
        title: initialItem == null
            ? LocalizationManager.local.addPayment
            : LocalizationManager.local.editPayment,
        submitButtonText: initialItem == null
            ? LocalizationManager.local.addPayment
            : LocalizationManager.local.editPayment,
      );
  @override
  BaseAddScreenState<Payment, AddPaymentScreen> createState() =>
      _AddPaymentScreenState();
}

class _AddPaymentScreenState
    extends BaseAddScreenState<Payment, AddPaymentScreen> {
  final _tenantIdController = TextEditingController();
  final _roomIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _typeController = TextEditingController();

  bool _isPaid = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final p = widget.initialItem;
    if (p != null) {
      _tenantIdController.text = p.tenantId ?? '';
      _roomIdController.text = p.roomId ?? '';
      _amountController.text = p.amount.toString();
      _typeController.text = p.type ?? '';
      _isPaid = p.isPaid;
      _selectedDate = p.datetime;
    }
  }

  @override
  void dispose() {
    _tenantIdController.dispose();
    _roomIdController.dispose();
    _amountController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  void onInit() {}

  @override
  void onDispose() {}

  @override
  Future<void> onSubmit() async {
    final payment = Payment(
      id: widget.initialItem != null ? widget.initialItem!.id : 0,
      tenantId: _tenantIdController.text.trim().isEmpty
          ? null
          : _tenantIdController.text.trim(),
      roomId: _roomIdController.text.trim().isEmpty
          ? null
          : _roomIdController.text.trim(),
      amount: int.parse(_amountController.text.trim()),
      isPaid: _isPaid,
      type: _typeController.text.trim().isEmpty
          ? 'rent'
          : _typeController.text.trim(),
      datetime: _selectedDate,
    );
    final provider = ref.read(paymentProvider.notifier);
    if (widget.initialItem != null) {
      await provider.updatePayment(payment);
    } else {
      await provider.addPayment(payment);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  List<Widget> buildFormFields() {
    return [..._buildFormFields()];
  }

  List<Widget> _buildFormFields() {
    return [
      // Amount Field
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationManager.local.amount,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.linear(0.7),
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: LocalizationManager.local.enterAmount,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocalizationManager.local.pleaseEnterAmount;
                  }
                  final amount = int.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return LocalizationManager.local.pleaseEnterValidAmount;
                  }
                  return null;
                },
                maxLength: 10,
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Tenant ID and Room ID Row
      Row(
        children: [
          // Tenant ID Field
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tenant ID',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.linear(0.7),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 12),
                      controller: _tenantIdController,
                      decoration: const InputDecoration(
                        hintText: 'Optional',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      maxLength: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Room ID Field
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room ID',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.linear(0.7),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 12),
                      controller: _roomIdController,
                      decoration: const InputDecoration(
                        hintText: 'Optional',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      maxLength: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 16),

      // Payment Type Field
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationManager.local.paymentType,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.linear(0.7),
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
                controller: _typeController,
                decoration: const InputDecoration(
                  hintText: 'rent, utilities, deposit, etc.',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                maxLength: 50,
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Date and Status Row
      Row(
        children: [
          // Date Field
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationManager.local.paymentDate,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.linear(0.7),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaler: TextScaler.linear(0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Payment Status
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationManager.local.paymentStatus,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.linear(0.7),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: Text(
                        _isPaid
                            ? LocalizationManager.local.paid
                            : LocalizationManager.local.unpaid,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(0.7),
                      ),
                      value: _isPaid,
                      onChanged: (value) {
                        setState(() {
                          _isPaid = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }
}
