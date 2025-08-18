part of 'components.dart';

class CustomCupertinoSwitch extends StatefulWidget {
  const CustomCupertinoSwitch({
    super.key,
    this.value,
    this.onChanged,
  });

  final bool? value;
  final ValueChanged<bool>? onChanged;

  @override
  State<CustomCupertinoSwitch> createState() => _CustomCupertinoSwitchState();
}

class _CustomCupertinoSwitchState extends State<CustomCupertinoSwitch> {
  bool _internalValue = false;

  bool get currentValue => widget.value ?? _internalValue;

  void _handleChanged(bool value) {
    final onChanged = widget.onChanged;
    if (onChanged != null) {
      onChanged(value);
    } else {
      setState(() {
        _internalValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: currentValue,
      onChanged: _handleChanged,
      activeTrackColor: const Color(0xFFFCE000),
    );
  }
}
