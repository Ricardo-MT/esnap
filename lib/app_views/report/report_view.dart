import 'package:esnap/app_views/report/report_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/utils/text_button_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:report_repository/report_repository.dart';
import 'package:wid_design_system/wid_design_system.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc(
        reportRepository: context.read<ReportRepository>(),
      ),
      child: const Center(
        child: WidTapToHideKeyboard(
          child: SingleChildScrollView(child: _ReportForm()),
        ),
      ),
    );
  }
}

class _ReportForm extends StatelessWidget {
  const _ReportForm();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Future.delayed(const Duration(seconds: 3), Navigator.of(context).pop);
        }
      },
      child: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state.status == FormzSubmissionStatus.inProgress) {
            return const AlertDialog(
              content: LinearProgressIndicator(),
            );
          }
          if (state.status == FormzSubmissionStatus.success) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.feedbackSentThanks,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  spacerM,
                  const Icon(Icons.check_circle, color: WidAppColors.success),
                ],
              ),
            );
          }
          return const AlertDialog.adaptive(
            title: _FeedbackTitle(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FeedbackDescription(),
                spacerL,
                _FeedbackTextInput(),
              ],
            ),
            actions: [
              _CancelButton(),
              _SendButton(),
            ],
          );
        },
      ),
    );
  }
}

class _FeedbackTitle extends StatelessWidget {
  const _FeedbackTitle();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(l10n.sendFeedbackCTA);
  }
}

class _FeedbackDescription extends StatelessWidget {
  const _FeedbackDescription();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(l10n.sendFeedbackDescription);
  }
}

class _FeedbackTextInput extends StatelessWidget {
  const _FeedbackTextInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (previous, current) => previous.message != current.message,
      builder: (context, state) {
        return TextField(
          key: const Key('reportForm_messageInput_textField'),
          onChanged: (message) => context
              .read<ReportBloc>()
              .add(ReportEventMessageChanged(message)),
          maxLines: 3,
          maxLength: 200,
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextButton(
      key: const Key('reportForm_cancelButton_textButton'),
      onPressed: () => Navigator.of(context).pop(),
      style: cancelButtonStyle(context),
      child: Text(l10n.cancel),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return TextButton(
          style: confirmButtonStyle(context),
          key: const Key('reportForm_continue_raisedButton'),
          onPressed: state.message.isNotEmpty
              ? () =>
                  context.read<ReportBloc>().add(const ReportEventSubmitted())
              : null,
          child: Text(l10n.send),
        );
      },
    );
  }
}
