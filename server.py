from flask import Flask, request, jsonify
import pyautogui

app = Flask(__name__)

@app.route('/move', methods=['POST'])
def move_mouse():
    data = request.get_json()
    x = data.get('x')
    y = data.get('y')

    # Move the mouse to the specified coordinates
    pyautogui.moveRel(x, y)  # Move the mouse by x, y relative to its current position

    return jsonify({'status': 'success'}), 200

@app.route('/click', methods=['POST'])
def click_mouse():
    pyautogui.click()  # Perform a click at the current mouse position
    return jsonify({'status': 'success'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # Listen on all network interfaces
