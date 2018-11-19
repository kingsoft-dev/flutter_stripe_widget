# Stripe Widget

A flutter plugin to integrate the stripe plugin for iOS and Android.
Currently only adding a credit card as source is implemented.

## Usage
To set your publishable key set:
```
import 'package:stripe_widget/stripe_widget.dart';
StripeWidget.setPublishableKey("pk_test");
```
from somewhere in your code, e.g. your main.dart file.

To open the dialog:

```
StripeWidget.addSource().then((String token) {
    print(token); //your stripe card source token
});
```

