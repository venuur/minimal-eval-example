# minimal-eval-example

Example eval problem in Racket to share on Slack.

To run, clone the git repo, install from the repo root:

```
git clone https://github.com/venuur/minimal-eval-example.git
cd minimal_eval_example
raco pkg install
```

Running `racket test-script.rkt` should print `123` to standard out.
The file `test-eval.rkt` is trying to setup a `rackunit` test that verifies that correct output
