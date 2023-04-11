export function register() {
  console.log(`Instrumenting ${process.env.NEXT_RUNTIME} runtime`);
  try {
    if (process.env.NEXT_RUNTIME === 'nodejs') {
      require('./instrumentation/applicationinsights').register();
    }
    console.log(`Done Instrumenting ${process.env.NEXT_RUNTIME} runtime`);
  } catch (err) {
    console.log(`Unable to instrument ${process.env.NEXT_RUNTIME} runtime`);
    console.error(err);
  }
}
