from flask import Flask, render_template, request, redirect, url_for
import subprocess

bulb_status_msg = ""

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html', status_msg=bulb_status_msg)

@app.route('/start', methods=['POST'])
def start():
    mode = request.form.get("mode", "1")  # Default to 1 if not provided
    try:
      subprocess.Popen(['./start.sh', mode])
      return redirect(url_for('index'))
    except Exception as e:
      return f"Error starting patch: {e}", 500

@app.route('/stop', methods=['POST'])
def stop():
    subprocess.Popen(['./stop.sh'])
    return redirect(url_for('index'))

@app.route('/shutdown', methods=['POST'])
def shutdown():
    subprocess.Popen(['./shutdown.sh'])
    return redirect(url_for('index'))

@app.route('/update', methods=['POST'])
def update():
    subprocess.Popen(['./update.sh'])
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

