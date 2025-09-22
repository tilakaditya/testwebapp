from flask import Flask, render_template, request, redirect, url_for, jsonify

app = Flask(__name__)

tasks = []

@app.route('/')
def index():
    return render_template('index.html', tasks=tasks)

@app.route("/healthz")
def health():
    return jsonify(status="ok"), 200

@app.route("/ready")
def ready():
    # perform lightweight checks (DB connectivity optionally)
    return jsonify(ready=True), 200

@app.route('/add', methods=['POST'])
def add():
    task = request.form['task']
    tasks.append(task)
    return redirect(url_for('index'))

@app.route('/delete/<int:task_id>')
def delete(task_id):
    if 0 <= task_id < len(tasks):
        del tasks[task_id]
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(host='0.0.0.0')
