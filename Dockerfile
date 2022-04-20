FROM dart:stable AS build


WORKDIR /app
COPY pubspec.* ./
RUN dart pub get


COPY . .

RUN dart pub get --offline
RUN dart compile exe lib/server.dart -o bootstrap 

FROM public.ecr.aws/lambda/provided

COPY --from=build /app/bootstrap ${LAMBDA_RUNTIME_DIR}

EXPOSE 8080
CMD ["activity.handler"]