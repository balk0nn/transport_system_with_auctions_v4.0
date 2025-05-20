import random
import argparse

POINTS = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]

def generate_passenger_agents(count):
    agents = []
    for i in range(1, count + 1):
        start = random.choice(POINTS)
        end = random.choice([p for p in POINTS if p != start])
        price = random.randint(200, 350)
        hour = random.randint(10, 12)
        minute = random.choice([0, 10, 20, 30, 40, 50])
        time_str = f"{hour:02d}:{minute:02d}"
        agent_block = f"""
    agent passenger{i} : passenger.asl {{
        join: auction_room
        focus: auction_room.notice_board
        beliefs: price({price}),
                 start_point("{start}"),
                 end_point("{end}"),
                 start_time("{time_str}"),
                 number({i})
    }}"""
        agents.append(agent_block)
    return "\n".join(agents)

def read_template(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def write_output(path, content):
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def main():
    parser = argparse.ArgumentParser(description="Generate .jcm with dynamic passengers")
    parser.add_argument('--count', type=int, default=10, help='Number of passenger agents')
    parser.add_argument('--template', default='template.jcm')
    parser.add_argument('--output', default='transport_system_with_auctions.jcm')
    args = parser.parse_args()

    print(f"Генерация {args.count} пассажиров...")
    template = read_template(args.template)
    passengers = generate_passenger_agents(args.count)
    result = template.replace("/*PASSENGERS*/", passengers)
    write_output(args.output, result)
    print(f"Файл {args.output} готов!")

if __name__ == "__main__":
    main()