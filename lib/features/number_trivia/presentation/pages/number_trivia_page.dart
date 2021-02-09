import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia/injection_container.dart';
import 'package:trivia/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class NumberTriviaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: buildBody(context)
      )
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: 'Start searching!');
                  }
                  else if (state is Loading) {
                    return LoadingWidget();
                  }
                  else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  }
                  else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                },
              ),
              SizedBox(height: 20),
              TriviaControls()
            ],
          ),
        ),
      )
    );
  }
}
