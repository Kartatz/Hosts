import asyncio
import functools
import socket
import json

import aiofiles

def gethostname(line):
	
	(
		address,
		hostname
	) = (
		line
			.split(sep = " ", maxsplit = 1)
	)
	
	host = hostname.strip()
	
	return host

async def agetaddrinfo(host):
	
	res = None
	
	print("Checking for %s" % (host))
	
	loop = asyncio.get_running_loop()
	
	func = functools.partial(
		socket.getaddrinfo,
		host = host,
		port = 80
	)
	
	try:
		res = await loop.run_in_executor(None, func)
	except socket.gaierror:
		pass
	
	print("res: %s" % str(res))
	
	return (host, res)

async def main():
	
	tasks = []
	mapping = {}
	
	finished = False
	
	async with (
		aiofiles.open(file = "./hosts", mode = "r") as file,
		aiofiles.open(file = "./hosts2", mode = "w") as file2
	):
		iterable = aiter(file)
		
		while True:
			line = await anext(iterable)
			host = gethostname(line = line)
			
			task = asyncio.create_task(
				coro = agetaddrinfo(host = host)
			)
			tasks.append(task)
			
			if len(tasks) == 1024:
				break
		
		task_index = -1
		total_tasks = (len(tasks) - 1)
		
		while True:
			task_index += 1
			
			if task_index > total_tasks:
				task_index -= task_index
				await asyncio.sleep(0.1)
			
			task = tasks[task_index]
			
			if task is None:
				if all(task is None for task in tasks):
					break
				
				continue
			
			done = task.done()
			
			if not done:
				continue
			
			result = task.result()
			
			(host, addresses) = result
			
			if addresses is not None:
				text = ":: %s\n" % (host)
				await file2.write(text)
				
				occurrences = 0
				
				for address in addresses:
					ip = address[-1][0]
					occurrences = mapping.get(ip)
					
					if occurrences is None:
						occurrences = 0
					
					occurrences += 1
					
					mapping.update(
						{
							ip: occurrences
						}
					)
			
			line = None
			
			try:
				line = await anext(iterable)
			except StopAsyncIteration:
				finished = True
			
			tasks[task_index] = None if finished else asyncio.create_task(
				coro = agetaddrinfo(
					host = gethostname(line = line)
				)
			)
	
	text = json.dumps(obj = mapping)
	
	async with aiofiles.open(file = "./mapping.json", mode = "w") as file:
		await file.write(text)

asyncio.run(main())
