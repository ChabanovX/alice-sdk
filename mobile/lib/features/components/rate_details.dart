part of 'components.dart';

class RateDetails extends StatefulWidget {
  const RateDetails({super.key, this.onChanged});

  final ValueChanged<Map<String, bool>>? onChanged;

  @override
  State<RateDetails> createState() => _RateDetailsState();
}

class _RateDetailsState extends State<RateDetails> {
  Map<String, bool> options = {
    'Вежливый пассажир': false,
    'Пассажир пристегнулся': false,
    'Бережное отношение к машине': false,
    'Точно указан маршрут': false,
    'Приятная беседа': false,
  };

  @override
  Widget build(BuildContext context) {
    final itemCount = options.length;
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final key = options.keys.elementAt(index);
        return Container(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    key,
                    style: context.textStyles.regular,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          options[key] = !options[key]!;
                        });
                        widget.onChanged?.call(options);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: options[key]!
                              ? context.colors.controlMain
                              : const Color(0x1A5C5A57),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: options[key]!
                            ? Center(child: SvgPicture.asset(AppIcons.check))
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              (index + 1 != itemCount)
              ? Divider(
                height: 2,
                color: context.colors.semanticBackgroundMirror,
              )
              : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
