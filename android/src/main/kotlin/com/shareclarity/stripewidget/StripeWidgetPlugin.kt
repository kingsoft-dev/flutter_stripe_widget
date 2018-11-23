package com.shareclarity.stripewidget

import android.app.Activity
import android.app.Dialog
import android.support.design.widget.Snackbar
import android.util.Log
import android.view.View
import android.view.Window
import com.stripe.android.SourceCallback
import com.stripe.android.Stripe
import com.stripe.android.TokenCallback
import com.stripe.android.model.Source
import com.stripe.android.model.SourceParams
import com.stripe.android.model.Token
import com.stripe.android.view.CardInputWidget
import com.stripe.android.view.CardMultilineWidget
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.Exception

class StripeWidgetPlugin(private val activity: Activity): MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "stripe_widget")
      channel.setMethodCallHandler(StripeWidgetPlugin(registrar.activity() as Activity))
    }
  }

  var publishableKey: String? = null
  var dialogs:Dialog = Dialog(activity)

    private fun showDialog(title: String, result:Result) {
        dialogs = Dialog(activity)
        dialogs.requestWindowFeature(Window.FEATURE_NO_TITLE)

        dialogs.setCancelable(true)

        dialogs.setContentView(R.layout.activity_stripe)
        dialogs.findViewById<View>(R.id.buttonCancel)?.setOnClickListener{
            dialogs.dismiss()
        }
        dialogs.findViewById<View>(R.id.buttonSave)?.setOnClickListener {
            val mCardInputWidget = dialogs.findViewById<View>(R.id.card_input_widget) as CardInputWidget

                mCardInputWidget.card?.let { card ->

                    dialogs.findViewById<View>(R.id.progress)?.visibility = View.VISIBLE
                    dialogs.findViewById<View>(R.id.buttonSave)?.visibility = View.GONE

                    val stripe = Stripe(activity!!, publishableKey)
                    stripe.createToken(card, object : TokenCallback {
                        override fun onSuccess(token: Token?) {
                            dialogs.findViewById<View>(R.id.progress)?.visibility = View.GONE
                            dialogs.findViewById<View>(R.id.buttonSave)?.visibility = View.GONE

                            if (token != null) {
                                result.success(token.id);
                                dialogs.dismiss()
                            }
                        }

                        override fun onError(error: Exception?) {
                            dialogs.findViewById<View>(R.id.progress)?.visibility = View.GONE
                            dialogs.findViewById<View>(R.id.buttonSave)?.visibility = View.VISIBLE
                            dialogs.let {
                                Snackbar.make(dialogs.findViewById(R.id.root_layout), error!!.localizedMessage, Snackbar.LENGTH_LONG).show()
                            }
                        }
                    });

                }
            }

        dialogs.show()
    }

  override fun onMethodCall(call: MethodCall, result: Result) {
      when (call.method) {
          "addSource" -> {
              publishableKey?.let {key ->
                  showDialog("Stripe", result)
              }
              if (publishableKey == null) {
                  Log.e("STRIPE", "You have to set a publishable key first")
                  result.success(false)
              }
          }
          "setPublishableKey" -> publishableKey = call.arguments as String
          else -> result.notImplemented()
      }
  }

}
