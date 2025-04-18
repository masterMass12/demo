from flask import Flask, render_template
import matplotlib.pyplot as plt

app = Flask(__name__)

# Sample quiz data (10 questions per category)
quiz_data = {
    "family_related": [1, 0, 1, 0, 1, 1, 0, 1, 0, 1],
    "recent_activity": [1, 1, 0, 0, 1, 0, 1, 1, 0, 0],
    "medication_related": [1, 0, 1, 1, 1, 0, 0, 1, 1, 0],
    "old_activity": [0, 1, 1, 0, 0, 1, 1, 0, 1, 1]
}

# Analyze quiz data
def analyze_quiz_data(quiz_data):
    performance = {}
    for category, answers in quiz_data.items():
        correct_answers = sum(answers)
        total_questions = len(answers)
        accuracy = (correct_answers / total_questions) * 100
        performance[category] = accuracy
    return performance

# Generate pie chart
def generate_pie_chart(data):
    labels = data.keys()
    sizes = data.values()
    plt.pie(sizes, labels=labels, autopct='%1.1f%%', startangle=140)
    plt.axis('equal')
    plt.title('Performance in Different Quiz Categories')
    plt.savefig('static/pie_chart.png')  # Save the pie chart as an image
    plt.close()

@app.route('/')
def index():
    performance = analyze_quiz_data(quiz_data)
    generate_pie_chart(performance)
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
