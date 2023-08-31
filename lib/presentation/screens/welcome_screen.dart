

// Future<void> selectLanguage() async {
  //   String? res = await showConfirmationDialog(
  //       context: context,
  //       title: S.of(context).choseLang,
  //       shrinkWrap: true,
  //       actions: <AlertDialogAction>[
  //         AlertDialogAction(
  //             key: 'en', label: S.of(context).english, isDefaultAction: true),
  //         AlertDialogAction(key: 'ru', label: S.of(context).russian),
  //       ]).catchError((error) {});
  //   if (res != null) {
  //     context.read<LocalizationProvider>().changeLocale(res);
  //   } else {}
  // }