
./build/tests/userprog/do-nothing:     file format elf32-i386


Disassembly of section .text:

08048094 <main>:
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	b8 a2 00 00 00       	mov    $0xa2,%eax
 804809c:	5d                   	pop    %ebp
 804809d:	c3                   	ret    

0804809e <fpu_push>:
 804809e:	55                   	push   %ebp
 804809f:	89 e5                	mov    %esp,%ebp
 80480a1:	ff 75 08             	push   0x8(%ebp)
 80480a4:	d9 04 24             	flds   (%esp)
 80480a7:	83 c4 04             	add    $0x4,%esp
 80480aa:	90                   	nop
 80480ab:	5d                   	pop    %ebp
 80480ac:	c3                   	ret    

080480ad <fpu_pop>:
 80480ad:	55                   	push   %ebp
 80480ae:	89 e5                	mov    %esp,%ebp
 80480b0:	83 ec 10             	sub    $0x10,%esp
 80480b3:	83 ec 04             	sub    $0x4,%esp
 80480b6:	d9 1c 24             	fstps  (%esp)
 80480b9:	8b 04 24             	mov    (%esp),%eax
 80480bc:	83 c4 04             	add    $0x4,%esp
 80480bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 80480c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80480c5:	89 ec                	mov    %ebp,%esp
 80480c7:	5d                   	pop    %ebp
 80480c8:	c3                   	ret    

080480c9 <console_init>:
 80480c9:	55                   	push   %ebp
 80480ca:	89 e5                	mov    %esp,%ebp
 80480cc:	83 ec 18             	sub    $0x18,%esp
 80480cf:	c7 04 24 26 ca 04 08 	movl   $0x804ca26,(%esp)
 80480d6:	e8 4a 02 00 00       	call   8048325 <lock_check_init>
 80480db:	90                   	nop
 80480dc:	89 ec                	mov    %ebp,%esp
 80480de:	5d                   	pop    %ebp
 80480df:	c3                   	ret    

080480e0 <vmsg>:
 80480e0:	55                   	push   %ebp
 80480e1:	89 e5                	mov    %esp,%ebp
 80480e3:	83 ec 18             	sub    $0x18,%esp
 80480e6:	89 5d fc             	mov    %ebx,-0x4(%ebp)
 80480e9:	a1 20 ca 04 08       	mov    0x804ca20,%eax
 80480ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
 80480f2:	c7 44 24 08 c0 b2 04 	movl   $0x804b2c0,0x8(%esp)
 80480f9:	08 
 80480fa:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
 8048101:	00 
 8048102:	c7 04 24 40 ca 04 08 	movl   $0x804ca40,(%esp)
 8048109:	e8 ba 0a 00 00       	call   8048bc8 <snprintf>
 804810e:	c7 04 24 40 ca 04 08 	movl   $0x804ca40,(%esp)
 8048115:	e8 30 23 00 00       	call   804a44a <strlen>
 804811a:	ba 00 04 00 00       	mov    $0x400,%edx
 804811f:	89 d3                	mov    %edx,%ebx
 8048121:	29 c3                	sub    %eax,%ebx
 8048123:	c7 04 24 40 ca 04 08 	movl   $0x804ca40,(%esp)
 804812a:	e8 1b 23 00 00       	call   804a44a <strlen>
 804812f:	8d 90 40 ca 04 08    	lea    0x804ca40(%eax),%edx
 8048135:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048138:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804813c:	8b 45 08             	mov    0x8(%ebp),%eax
 804813f:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048143:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048147:	89 14 24             	mov    %edx,(%esp)
 804814a:	e8 db 09 00 00       	call   8048b2a <vsnprintf>
 804814f:	c7 04 24 40 ca 04 08 	movl   $0x804ca40,(%esp)
 8048156:	e8 ef 22 00 00       	call   804a44a <strlen>
 804815b:	ba 00 04 00 00       	mov    $0x400,%edx
 8048160:	89 d3                	mov    %edx,%ebx
 8048162:	29 c3                	sub    %eax,%ebx
 8048164:	c7 04 24 40 ca 04 08 	movl   $0x804ca40,(%esp)
 804816b:	e8 da 22 00 00       	call   804a44a <strlen>
 8048170:	8d 90 40 ca 04 08    	lea    0x804ca40(%eax),%edx
 8048176:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 804817a:	8b 45 10             	mov    0x10(%ebp),%eax
 804817d:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048181:	89 14 24             	mov    %edx,(%esp)
 8048184:	e8 4a 23 00 00       	call   804a4d3 <strlcpy>
 8048189:	c7 04 24 40 ca 04 08 	movl   $0x804ca40,(%esp)
 8048190:	e8 b5 22 00 00       	call   804a44a <strlen>
 8048195:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048199:	c7 44 24 04 40 ca 04 	movl   $0x804ca40,0x4(%esp)
 80481a0:	08 
 80481a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 80481a8:	e8 5b 2b 00 00       	call   804ad08 <write>
 80481ad:	90                   	nop
 80481ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 80481b1:	89 ec                	mov    %ebp,%esp
 80481b3:	5d                   	pop    %ebp
 80481b4:	c3                   	ret    

080481b5 <msg>:
 80481b5:	55                   	push   %ebp
 80481b6:	89 e5                	mov    %esp,%ebp
 80481b8:	83 ec 28             	sub    $0x28,%esp
 80481bb:	0f b6 05 24 ca 04 08 	movzbl 0x804ca24,%eax
 80481c2:	84 c0                	test   %al,%al
 80481c4:	75 50                	jne    8048216 <msg+0x61>
 80481c6:	0f b6 05 25 ca 04 08 	movzbl 0x804ca25,%eax
 80481cd:	84 c0                	test   %al,%al
 80481cf:	74 0c                	je     80481dd <msg+0x28>
 80481d1:	c7 04 24 26 ca 04 08 	movl   $0x804ca26,(%esp)
 80481d8:	e8 19 2d 00 00       	call   804aef6 <lock_acquire>
 80481dd:	8d 45 0c             	lea    0xc(%ebp),%eax
 80481e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80481e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80481e6:	c7 44 24 08 c6 b2 04 	movl   $0x804b2c6,0x8(%esp)
 80481ed:	08 
 80481ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 80481f2:	8b 45 08             	mov    0x8(%ebp),%eax
 80481f5:	89 04 24             	mov    %eax,(%esp)
 80481f8:	e8 e3 fe ff ff       	call   80480e0 <vmsg>
 80481fd:	0f b6 05 25 ca 04 08 	movzbl 0x804ca25,%eax
 8048204:	84 c0                	test   %al,%al
 8048206:	74 0f                	je     8048217 <msg+0x62>
 8048208:	c7 04 24 26 ca 04 08 	movl   $0x804ca26,(%esp)
 804820f:	e8 1b 2d 00 00       	call   804af2f <lock_release>
 8048214:	eb 01                	jmp    8048217 <msg+0x62>
 8048216:	90                   	nop
 8048217:	89 ec                	mov    %ebp,%esp
 8048219:	5d                   	pop    %ebp
 804821a:	c3                   	ret    

0804821b <fail>:
 804821b:	55                   	push   %ebp
 804821c:	89 e5                	mov    %esp,%ebp
 804821e:	83 ec 28             	sub    $0x28,%esp
 8048221:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048224:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048227:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804822a:	c7 44 24 08 c8 b2 04 	movl   $0x804b2c8,0x8(%esp)
 8048231:	08 
 8048232:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048236:	8b 45 08             	mov    0x8(%ebp),%eax
 8048239:	89 04 24             	mov    %eax,(%esp)
 804823c:	e8 9f fe ff ff       	call   80480e0 <vmsg>
 8048241:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048248:	e8 b6 29 00 00       	call   804ac03 <exit>

0804824d <swap>:
 804824d:	55                   	push   %ebp
 804824e:	89 e5                	mov    %esp,%ebp
 8048250:	83 ec 10             	sub    $0x10,%esp
 8048253:	8b 45 08             	mov    0x8(%ebp),%eax
 8048256:	89 45 f8             	mov    %eax,-0x8(%ebp)
 8048259:	8b 45 0c             	mov    0xc(%ebp),%eax
 804825c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804825f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048266:	eb 34                	jmp    804829c <swap+0x4f>
 8048268:	8b 55 f8             	mov    -0x8(%ebp),%edx
 804826b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804826e:	01 d0                	add    %edx,%eax
 8048270:	0f b6 00             	movzbl (%eax),%eax
 8048273:	88 45 f3             	mov    %al,-0xd(%ebp)
 8048276:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048279:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804827c:	01 c2                	add    %eax,%edx
 804827e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 8048281:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048284:	01 c8                	add    %ecx,%eax
 8048286:	0f b6 12             	movzbl (%edx),%edx
 8048289:	88 10                	mov    %dl,(%eax)
 804828b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804828e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048291:	01 d0                	add    %edx,%eax
 8048293:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
 8048297:	88 10                	mov    %dl,(%eax)
 8048299:	ff 45 fc             	incl   -0x4(%ebp)
 804829c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804829f:	3b 45 10             	cmp    0x10(%ebp),%eax
 80482a2:	72 c4                	jb     8048268 <swap+0x1b>
 80482a4:	90                   	nop
 80482a5:	90                   	nop
 80482a6:	89 ec                	mov    %ebp,%esp
 80482a8:	5d                   	pop    %ebp
 80482a9:	c3                   	ret    

080482aa <push_values_to_fpu>:
 80482aa:	55                   	push   %ebp
 80482ab:	89 e5                	mov    %esp,%ebp
 80482ad:	83 ec 14             	sub    $0x14,%esp
 80482b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 80482b7:	eb 1c                	jmp    80482d5 <push_values_to_fpu+0x2b>
 80482b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 80482c3:	8b 45 08             	mov    0x8(%ebp),%eax
 80482c6:	01 d0                	add    %edx,%eax
 80482c8:	8b 00                	mov    (%eax),%eax
 80482ca:	89 04 24             	mov    %eax,(%esp)
 80482cd:	e8 cc fd ff ff       	call   804809e <fpu_push>
 80482d2:	ff 45 fc             	incl   -0x4(%ebp)
 80482d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 80482db:	7c dc                	jl     80482b9 <push_values_to_fpu+0xf>
 80482dd:	90                   	nop
 80482de:	90                   	nop
 80482df:	89 ec                	mov    %ebp,%esp
 80482e1:	5d                   	pop    %ebp
 80482e2:	c3                   	ret    

080482e3 <pop_values_from_fpu>:
 80482e3:	55                   	push   %ebp
 80482e4:	89 e5                	mov    %esp,%ebp
 80482e6:	83 ec 14             	sub    $0x14,%esp
 80482e9:	89 5d fc             	mov    %ebx,-0x4(%ebp)
 80482ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 80482ef:	48                   	dec    %eax
 80482f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
 80482f3:	eb 21                	jmp    8048316 <pop_values_from_fpu+0x33>
 80482f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80482f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 80482ff:	8b 45 08             	mov    0x8(%ebp),%eax
 8048302:	01 d0                	add    %edx,%eax
 8048304:	8b 18                	mov    (%eax),%ebx
 8048306:	e8 a2 fd ff ff       	call   80480ad <fpu_pop>
 804830b:	39 c3                	cmp    %eax,%ebx
 804830d:	74 04                	je     8048313 <pop_values_from_fpu+0x30>
 804830f:	b0 00                	mov    $0x0,%al
 8048311:	eb 0b                	jmp    804831e <pop_values_from_fpu+0x3b>
 8048313:	ff 4d f8             	decl   -0x8(%ebp)
 8048316:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 804831a:	79 d9                	jns    80482f5 <pop_values_from_fpu+0x12>
 804831c:	b0 01                	mov    $0x1,%al
 804831e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048321:	89 ec                	mov    %ebp,%esp
 8048323:	5d                   	pop    %ebp
 8048324:	c3                   	ret    

08048325 <lock_check_init>:
 8048325:	55                   	push   %ebp
 8048326:	89 e5                	mov    %esp,%ebp
 8048328:	83 ec 18             	sub    $0x18,%esp
 804832b:	8b 45 08             	mov    0x8(%ebp),%eax
 804832e:	89 04 24             	mov    %eax,(%esp)
 8048331:	e8 a1 2b 00 00       	call   804aed7 <lock_init>
 8048336:	34 01                	xor    $0x1,%al
 8048338:	84 c0                	test   %al,%al
 804833a:	74 0c                	je     8048348 <lock_check_init+0x23>
 804833c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048343:	e8 bb 28 00 00       	call   804ac03 <exit>
 8048348:	90                   	nop
 8048349:	89 ec                	mov    %ebp,%esp
 804834b:	5d                   	pop    %ebp
 804834c:	c3                   	ret    

0804834d <sema_check_init>:
 804834d:	55                   	push   %ebp
 804834e:	89 e5                	mov    %esp,%ebp
 8048350:	83 ec 18             	sub    $0x18,%esp
 8048353:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048356:	89 44 24 04          	mov    %eax,0x4(%esp)
 804835a:	8b 45 08             	mov    0x8(%ebp),%eax
 804835d:	89 04 24             	mov    %eax,(%esp)
 8048360:	e8 03 2c 00 00       	call   804af68 <sema_init>
 8048365:	34 01                	xor    $0x1,%al
 8048367:	84 c0                	test   %al,%al
 8048369:	74 0c                	je     8048377 <sema_check_init+0x2a>
 804836b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048372:	e8 8c 28 00 00       	call   804ac03 <exit>
 8048377:	90                   	nop
 8048378:	89 ec                	mov    %ebp,%esp
 804837a:	5d                   	pop    %ebp
 804837b:	c3                   	ret    

0804837c <pthread_check_join>:
 804837c:	55                   	push   %ebp
 804837d:	89 e5                	mov    %esp,%ebp
 804837f:	83 ec 18             	sub    $0x18,%esp
 8048382:	8b 45 08             	mov    0x8(%ebp),%eax
 8048385:	89 04 24             	mov    %eax,(%esp)
 8048388:	e8 b7 2c 00 00       	call   804b044 <pthread_join>
 804838d:	34 01                	xor    $0x1,%al
 804838f:	84 c0                	test   %al,%al
 8048391:	74 0c                	je     804839f <pthread_check_join+0x23>
 8048393:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804839a:	e8 64 28 00 00       	call   804ac03 <exit>
 804839f:	90                   	nop
 80483a0:	89 ec                	mov    %ebp,%esp
 80483a2:	5d                   	pop    %ebp
 80483a3:	c3                   	ret    

080483a4 <pthread_check_create>:
 80483a4:	55                   	push   %ebp
 80483a5:	89 e5                	mov    %esp,%ebp
 80483a7:	83 ec 28             	sub    $0x28,%esp
 80483aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 80483ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 80483b1:	8b 45 08             	mov    0x8(%ebp),%eax
 80483b4:	89 04 24             	mov    %eax,(%esp)
 80483b7:	e8 59 2c 00 00       	call   804b015 <pthread_create>
 80483bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80483bf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 80483c3:	75 0c                	jne    80483d1 <pthread_check_create+0x2d>
 80483c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 80483cc:	e8 32 28 00 00       	call   804ac03 <exit>
 80483d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483d4:	89 ec                	mov    %ebp,%esp
 80483d6:	5d                   	pop    %ebp
 80483d7:	c3                   	ret    

080483d8 <shuffle>:
 80483d8:	55                   	push   %ebp
 80483d9:	89 e5                	mov    %esp,%ebp
 80483db:	83 ec 28             	sub    $0x28,%esp
 80483de:	8b 45 08             	mov    0x8(%ebp),%eax
 80483e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80483e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80483eb:	eb 4f                	jmp    804843c <shuffle+0x64>
 80483ed:	e8 de 06 00 00       	call   8048ad0 <random_ulong>
 80483f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 80483f5:	89 d1                	mov    %edx,%ecx
 80483f7:	2b 4d f4             	sub    -0xc(%ebp),%ecx
 80483fa:	ba 00 00 00 00       	mov    $0x0,%edx
 80483ff:	f7 f1                	div    %ecx
 8048401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048404:	01 d0                	add    %edx,%eax
 8048406:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8048409:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804840c:	0f af 45 10          	imul   0x10(%ebp),%eax
 8048410:	89 c2                	mov    %eax,%edx
 8048412:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048415:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804841b:	0f af 45 10          	imul   0x10(%ebp),%eax
 804841f:	89 c2                	mov    %eax,%edx
 8048421:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048424:	01 c2                	add    %eax,%edx
 8048426:	8b 45 10             	mov    0x10(%ebp),%eax
 8048429:	89 44 24 08          	mov    %eax,0x8(%esp)
 804842d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8048431:	89 14 24             	mov    %edx,(%esp)
 8048434:	e8 14 fe ff ff       	call   804824d <swap>
 8048439:	ff 45 f4             	incl   -0xc(%ebp)
 804843c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804843f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 8048442:	72 a9                	jb     80483ed <shuffle+0x15>
 8048444:	90                   	nop
 8048445:	90                   	nop
 8048446:	89 ec                	mov    %ebp,%esp
 8048448:	5d                   	pop    %ebp
 8048449:	c3                   	ret    

0804844a <exec_children>:
 804844a:	55                   	push   %ebp
 804844b:	89 e5                	mov    %esp,%ebp
 804844d:	81 ec b8 00 00 00    	sub    $0xb8,%esp
 8048453:	89 5d fc             	mov    %ebx,-0x4(%ebp)
 8048456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 804845d:	e9 a4 00 00 00       	jmp    8048506 <exec_children+0xbc>
 8048462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048465:	89 44 24 10          	mov    %eax,0x10(%esp)
 8048469:	8b 45 08             	mov    0x8(%ebp),%eax
 804846c:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048470:	c7 44 24 08 d2 b2 04 	movl   $0x804b2d2,0x8(%esp)
 8048477:	08 
 8048478:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
 804847f:	00 
 8048480:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
 8048486:	89 04 24             	mov    %eax,(%esp)
 8048489:	e8 3a 07 00 00       	call   8048bc8 <snprintf>
 804848e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048491:	8d 50 01             	lea    0x1(%eax),%edx
 8048494:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
 804849a:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804849e:	8b 45 10             	mov    0x10(%ebp),%eax
 80484a1:	89 44 24 08          	mov    %eax,0x8(%esp)
 80484a5:	89 54 24 04          	mov    %edx,0x4(%esp)
 80484a9:	c7 04 24 d9 b2 04 08 	movl   $0x804b2d9,(%esp)
 80484b0:	e8 00 fd ff ff       	call   80481b5 <msg>
 80484b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 80484bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 80484c2:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 80484c5:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
 80484cb:	89 04 24             	mov    %eax,(%esp)
 80484ce:	e8 67 27 00 00       	call   804ac3a <exec>
 80484d3:	89 03                	mov    %eax,(%ebx)
 80484d5:	8b 03                	mov    (%ebx),%eax
 80484d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 80484da:	75 27                	jne    8048503 <exec_children+0xb9>
 80484dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484df:	8d 50 01             	lea    0x1(%eax),%edx
 80484e2:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
 80484e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 80484ec:	8b 45 10             	mov    0x10(%ebp),%eax
 80484ef:	89 44 24 08          	mov    %eax,0x8(%esp)
 80484f3:	89 54 24 04          	mov    %edx,0x4(%esp)
 80484f7:	c7 04 24 d9 b2 04 08 	movl   $0x804b2d9,(%esp)
 80484fe:	e8 18 fd ff ff       	call   804821b <fail>
 8048503:	ff 45 f4             	incl   -0xc(%ebp)
 8048506:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048509:	3b 45 10             	cmp    0x10(%ebp),%eax
 804850c:	0f 82 50 ff ff ff    	jb     8048462 <exec_children+0x18>
 8048512:	90                   	nop
 8048513:	90                   	nop
 8048514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048517:	89 ec                	mov    %ebp,%esp
 8048519:	5d                   	pop    %ebp
 804851a:	c3                   	ret    

0804851b <wait_children>:
 804851b:	55                   	push   %ebp
 804851c:	89 e5                	mov    %esp,%ebp
 804851e:	83 ec 38             	sub    $0x38,%esp
 8048521:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048528:	eb 7d                	jmp    80485a7 <wait_children+0x8c>
 804852a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804852d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 8048534:	8b 45 08             	mov    0x8(%ebp),%eax
 8048537:	01 d0                	add    %edx,%eax
 8048539:	8b 00                	mov    (%eax),%eax
 804853b:	89 04 24             	mov    %eax,(%esp)
 804853e:	e8 11 27 00 00       	call   804ac54 <wait>
 8048543:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048546:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048549:	8d 50 01             	lea    0x1(%eax),%edx
 804854c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804854f:	89 44 24 10          	mov    %eax,0x10(%esp)
 8048553:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048556:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804855a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804855d:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048561:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048565:	c7 04 24 f8 b2 04 08 	movl   $0x804b2f8,(%esp)
 804856c:	e8 44 fc ff ff       	call   80481b5 <msg>
 8048571:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048574:	39 45 f0             	cmp    %eax,-0x10(%ebp)
 8048577:	74 2b                	je     80485a4 <wait_children+0x89>
 8048579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804857c:	8d 50 01             	lea    0x1(%eax),%edx
 804857f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048582:	89 44 24 10          	mov    %eax,0x10(%esp)
 8048586:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048589:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804858d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048590:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048594:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048598:	c7 04 24 f8 b2 04 08 	movl   $0x804b2f8,(%esp)
 804859f:	e8 77 fc ff ff       	call   804821b <fail>
 80485a4:	ff 45 f4             	incl   -0xc(%ebp)
 80485a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
 80485ad:	0f 82 77 ff ff ff    	jb     804852a <wait_children+0xf>
 80485b3:	90                   	nop
 80485b4:	90                   	nop
 80485b5:	89 ec                	mov    %ebp,%esp
 80485b7:	5d                   	pop    %ebp
 80485b8:	c3                   	ret    

080485b9 <check_file_handle>:
 80485b9:	55                   	push   %ebp
 80485ba:	89 e5                	mov    %esp,%ebp
 80485bc:	81 ec 48 02 00 00    	sub    $0x248,%esp
 80485c2:	8b 45 10             	mov    0x10(%ebp),%eax
 80485c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 80485c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80485cf:	8b 45 08             	mov    0x8(%ebp),%eax
 80485d2:	89 04 24             	mov    %eax,(%esp)
 80485d5:	e8 f1 26 00 00       	call   804accb <filesize>
 80485da:	89 45 e8             	mov    %eax,-0x18(%ebp)
 80485dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485e0:	3b 45 14             	cmp    0x14(%ebp),%eax
 80485e3:	0f 84 c3 00 00 00    	je     80486ac <check_file_handle+0xf3>
 80485e9:	8b 45 14             	mov    0x14(%ebp),%eax
 80485ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
 80485f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485f3:	89 44 24 08          	mov    %eax,0x8(%esp)
 80485f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 80485fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 80485fe:	c7 04 24 30 b3 04 08 	movl   $0x804b330,(%esp)
 8048605:	e8 ab fb ff ff       	call   80481b5 <msg>
 804860a:	e9 9d 00 00 00       	jmp    80486ac <check_file_handle+0xf3>
 804860f:	8b 45 14             	mov    0x14(%ebp),%eax
 8048612:	2b 45 f4             	sub    -0xc(%ebp),%eax
 8048615:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048618:	81 7d f0 00 02 00 00 	cmpl   $0x200,-0x10(%ebp)
 804861f:	76 07                	jbe    8048628 <check_file_handle+0x6f>
 8048621:	c7 45 f0 00 02 00 00 	movl   $0x200,-0x10(%ebp)
 8048628:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804862b:	89 44 24 08          	mov    %eax,0x8(%esp)
 804862f:	8d 85 e4 fd ff ff    	lea    -0x21c(%ebp),%eax
 8048635:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048639:	8b 45 08             	mov    0x8(%ebp),%eax
 804863c:	89 04 24             	mov    %eax,(%esp)
 804863f:	e8 a1 26 00 00       	call   804ace5 <read>
 8048644:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8048647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804864a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 804864d:	74 28                	je     8048677 <check_file_handle+0xbe>
 804864f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048652:	89 44 24 10          	mov    %eax,0x10(%esp)
 8048656:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048659:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804865d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048660:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048664:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048667:	89 44 24 04          	mov    %eax,0x4(%esp)
 804866b:	c7 04 24 60 b3 04 08 	movl   $0x804b360,(%esp)
 8048672:	e8 a4 fb ff ff       	call   804821b <fail>
 8048677:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804867a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804867d:	01 c2                	add    %eax,%edx
 804867f:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048682:	89 44 24 10          	mov    %eax,0x10(%esp)
 8048686:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048689:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804868d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048690:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048694:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048698:	8d 85 e4 fd ff ff    	lea    -0x21c(%ebp),%eax
 804869e:	89 04 24             	mov    %eax,(%esp)
 80486a1:	e8 d6 00 00 00       	call   804877c <compare_bytes>
 80486a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80486a9:	01 45 f4             	add    %eax,-0xc(%ebp)
 80486ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80486af:	3b 45 14             	cmp    0x14(%ebp),%eax
 80486b2:	0f 82 57 ff ff ff    	jb     804860f <check_file_handle+0x56>
 80486b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80486bb:	3b 45 14             	cmp    0x14(%ebp),%eax
 80486be:	74 21                	je     80486e1 <check_file_handle+0x128>
 80486c0:	8b 45 14             	mov    0x14(%ebp),%eax
 80486c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
 80486c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80486ca:	89 44 24 08          	mov    %eax,0x8(%esp)
 80486ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 80486d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 80486d5:	c7 04 24 30 b3 04 08 	movl   $0x804b330,(%esp)
 80486dc:	e8 3a fb ff ff       	call   804821b <fail>
 80486e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 80486e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 80486e8:	c7 04 24 95 b3 04 08 	movl   $0x804b395,(%esp)
 80486ef:	e8 c1 fa ff ff       	call   80481b5 <msg>
 80486f4:	90                   	nop
 80486f5:	89 ec                	mov    %ebp,%esp
 80486f7:	5d                   	pop    %ebp
 80486f8:	c3                   	ret    

080486f9 <check_file>:
 80486f9:	55                   	push   %ebp
 80486fa:	89 e5                	mov    %esp,%ebp
 80486fc:	83 ec 28             	sub    $0x28,%esp
 80486ff:	8b 45 08             	mov    0x8(%ebp),%eax
 8048702:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048706:	c7 04 24 af b3 04 08 	movl   $0x804b3af,(%esp)
 804870d:	e8 a3 fa ff ff       	call   80481b5 <msg>
 8048712:	8b 45 08             	mov    0x8(%ebp),%eax
 8048715:	89 04 24             	mov    %eax,(%esp)
 8048718:	e8 94 25 00 00       	call   804acb1 <open>
 804871d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048720:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
 8048724:	7f 13                	jg     8048739 <check_file+0x40>
 8048726:	8b 45 08             	mov    0x8(%ebp),%eax
 8048729:	89 44 24 04          	mov    %eax,0x4(%esp)
 804872d:	c7 04 24 af b3 04 08 	movl   $0x804b3af,(%esp)
 8048734:	e8 e2 fa ff ff       	call   804821b <fail>
 8048739:	8b 45 10             	mov    0x10(%ebp),%eax
 804873c:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048740:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048743:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048747:	8b 45 08             	mov    0x8(%ebp),%eax
 804874a:	89 44 24 04          	mov    %eax,0x4(%esp)
 804874e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048751:	89 04 24             	mov    %eax,(%esp)
 8048754:	e8 60 fe ff ff       	call   80485b9 <check_file_handle>
 8048759:	8b 45 08             	mov    0x8(%ebp),%eax
 804875c:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048760:	c7 04 24 ca b3 04 08 	movl   $0x804b3ca,(%esp)
 8048767:	e8 49 fa ff ff       	call   80481b5 <msg>
 804876c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804876f:	89 04 24             	mov    %eax,(%esp)
 8048772:	e8 eb 25 00 00       	call   804ad62 <close>
 8048777:	90                   	nop
 8048778:	89 ec                	mov    %ebp,%esp
 804877a:	5d                   	pop    %ebp
 804877b:	c3                   	ret    

0804877c <compare_bytes>:
 804877c:	55                   	push   %ebp
 804877d:	89 e5                	mov    %esp,%ebp
 804877f:	83 ec 38             	sub    $0x38,%esp
 8048782:	8b 45 08             	mov    0x8(%ebp),%eax
 8048785:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048788:	8b 45 0c             	mov    0xc(%ebp),%eax
 804878b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 804878e:	8b 45 10             	mov    0x10(%ebp),%eax
 8048791:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048798:	89 44 24 04          	mov    %eax,0x4(%esp)
 804879c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804879f:	89 04 24             	mov    %eax,(%esp)
 80487a2:	e8 15 17 00 00       	call   8049ebc <memcmp>
 80487a7:	85 c0                	test   %eax,%eax
 80487a9:	0f 84 5b 01 00 00    	je     804890a <compare_bytes+0x18e>
 80487af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80487b6:	eb 1d                	jmp    80487d5 <compare_bytes+0x59>
 80487b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
 80487bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80487be:	01 d0                	add    %edx,%eax
 80487c0:	0f b6 10             	movzbl (%eax),%edx
 80487c3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 80487c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80487c9:	01 c8                	add    %ecx,%eax
 80487cb:	0f b6 00             	movzbl (%eax),%eax
 80487ce:	38 c2                	cmp    %al,%dl
 80487d0:	75 0d                	jne    80487df <compare_bytes+0x63>
 80487d2:	ff 45 f4             	incl   -0xc(%ebp)
 80487d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80487d8:	3b 45 10             	cmp    0x10(%ebp),%eax
 80487db:	72 db                	jb     80487b8 <compare_bytes+0x3c>
 80487dd:	eb 01                	jmp    80487e0 <compare_bytes+0x64>
 80487df:	90                   	nop
 80487e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80487e3:	40                   	inc    %eax
 80487e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80487e7:	eb 1d                	jmp    8048806 <compare_bytes+0x8a>
 80487e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
 80487ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80487ef:	01 d0                	add    %edx,%eax
 80487f1:	0f b6 10             	movzbl (%eax),%edx
 80487f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 80487f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80487fa:	01 c8                	add    %ecx,%eax
 80487fc:	0f b6 00             	movzbl (%eax),%eax
 80487ff:	38 c2                	cmp    %al,%dl
 8048801:	74 0d                	je     8048810 <compare_bytes+0x94>
 8048803:	ff 45 f0             	incl   -0x10(%ebp)
 8048806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048809:	3b 45 10             	cmp    0x10(%ebp),%eax
 804880c:	72 db                	jb     80487e9 <compare_bytes+0x6d>
 804880e:	eb 01                	jmp    8048811 <compare_bytes+0x95>
 8048810:	90                   	nop
 8048811:	c6 05 24 ca 04 08 00 	movb   $0x0,0x804ca24
 8048818:	8b 55 14             	mov    0x14(%ebp),%edx
 804881b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804881e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048824:	2b 45 f4             	sub    -0xc(%ebp),%eax
 8048827:	8b 55 18             	mov    0x18(%ebp),%edx
 804882a:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804882e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 8048832:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048836:	c7 04 24 d8 b3 04 08 	movl   $0x804b3d8,(%esp)
 804883d:	e8 73 f9 ff ff       	call   80481b5 <msg>
 8048842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048845:	2b 45 f4             	sub    -0xc(%ebp),%eax
 8048848:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804884b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804884e:	2b 45 f4             	sub    -0xc(%ebp),%eax
 8048851:	83 f8 40             	cmp    $0x40,%eax
 8048854:	76 1a                	jbe    8048870 <compare_bytes+0xf4>
 8048856:	c7 45 ec 40 00 00 00 	movl   $0x40,-0x14(%ebp)
 804885d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048860:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048864:	c7 04 24 1c b4 04 08 	movl   $0x804b41c,(%esp)
 804886b:	e8 45 f9 ff ff       	call   80481b5 <msg>
 8048870:	c7 04 24 3f b4 04 08 	movl   $0x804b43f,(%esp)
 8048877:	e8 39 f9 ff ff       	call   80481b5 <msg>
 804887c:	8b 55 e8             	mov    -0x18(%ebp),%edx
 804887f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048882:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048885:	8b 55 14             	mov    0x14(%ebp),%edx
 8048888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804888b:	01 c2                	add    %eax,%edx
 804888d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8048894:	00 
 8048895:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048898:	89 44 24 08          	mov    %eax,0x8(%esp)
 804889c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 80488a0:	89 14 24             	mov    %edx,(%esp)
 80488a3:	e8 12 12 00 00       	call   8049aba <hex_dump>
 80488a8:	c7 04 24 53 b4 04 08 	movl   $0x804b453,(%esp)
 80488af:	e8 01 f9 ff ff       	call   80481b5 <msg>
 80488b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 80488b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488ba:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80488bd:	8b 55 14             	mov    0x14(%ebp),%edx
 80488c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488c3:	01 c2                	add    %eax,%edx
 80488c5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 80488cc:	00 
 80488cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80488d0:	89 44 24 08          	mov    %eax,0x8(%esp)
 80488d4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 80488d8:	89 14 24             	mov    %edx,(%esp)
 80488db:	e8 da 11 00 00       	call   8049aba <hex_dump>
 80488e0:	8b 55 14             	mov    0x14(%ebp),%edx
 80488e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488e6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80488e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80488ec:	2b 45 f4             	sub    -0xc(%ebp),%eax
 80488ef:	8b 55 18             	mov    0x18(%ebp),%edx
 80488f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
 80488f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 80488fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 80488fe:	c7 04 24 64 b4 04 08 	movl   $0x804b464,(%esp)
 8048905:	e8 11 f9 ff ff       	call   804821b <fail>
 804890a:	90                   	nop
 804890b:	89 ec                	mov    %ebp,%esp
 804890d:	5d                   	pop    %ebp
 804890e:	c3                   	ret    

0804890f <_start>:
 804890f:	55                   	push   %ebp
 8048910:	89 e5                	mov    %esp,%ebp
 8048912:	83 ec 18             	sub    $0x18,%esp
 8048915:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048918:	89 44 24 04          	mov    %eax,0x4(%esp)
 804891c:	8b 45 08             	mov    0x8(%ebp),%eax
 804891f:	89 04 24             	mov    %eax,(%esp)
 8048922:	e8 6d f7 ff ff       	call   8048094 <main>
 8048927:	89 04 24             	mov    %eax,(%esp)
 804892a:	e8 d4 22 00 00       	call   804ac03 <exit>

0804892f <swap_byte>:
 804892f:	55                   	push   %ebp
 8048930:	89 e5                	mov    %esp,%ebp
 8048932:	83 ec 10             	sub    $0x10,%esp
 8048935:	8b 45 08             	mov    0x8(%ebp),%eax
 8048938:	0f b6 00             	movzbl (%eax),%eax
 804893b:	88 45 ff             	mov    %al,-0x1(%ebp)
 804893e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048941:	0f b6 10             	movzbl (%eax),%edx
 8048944:	8b 45 08             	mov    0x8(%ebp),%eax
 8048947:	88 10                	mov    %dl,(%eax)
 8048949:	8b 45 0c             	mov    0xc(%ebp),%eax
 804894c:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
 8048950:	88 10                	mov    %dl,(%eax)
 8048952:	90                   	nop
 8048953:	89 ec                	mov    %ebp,%esp
 8048955:	5d                   	pop    %ebp
 8048956:	c3                   	ret    

08048957 <random_init>:
 8048957:	55                   	push   %ebp
 8048958:	89 e5                	mov    %esp,%ebp
 804895a:	83 ec 18             	sub    $0x18,%esp
 804895d:	8d 45 08             	lea    0x8(%ebp),%eax
 8048960:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048963:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804896a:	eb 12                	jmp    804897e <random_init+0x27>
 804896c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804896f:	88 c2                	mov    %al,%dl
 8048971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048974:	05 40 ce 04 08       	add    $0x804ce40,%eax
 8048979:	88 10                	mov    %dl,(%eax)
 804897b:	ff 45 fc             	incl   -0x4(%ebp)
 804897e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
 8048985:	7e e5                	jle    804896c <random_init+0x15>
 8048987:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
 804898b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048992:	eb 41                	jmp    80489d5 <random_init+0x7e>
 8048994:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048997:	05 40 ce 04 08       	add    $0x804ce40,%eax
 804899c:	0f b6 10             	movzbl (%eax),%edx
 804899f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80489a2:	83 e0 03             	and    $0x3,%eax
 80489a5:	89 c1                	mov    %eax,%ecx
 80489a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489aa:	01 c8                	add    %ecx,%eax
 80489ac:	0f b6 00             	movzbl (%eax),%eax
 80489af:	00 d0                	add    %dl,%al
 80489b1:	00 45 fb             	add    %al,-0x5(%ebp)
 80489b4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
 80489b8:	8d 90 40 ce 04 08    	lea    0x804ce40(%eax),%edx
 80489be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80489c1:	05 40 ce 04 08       	add    $0x804ce40,%eax
 80489c6:	89 54 24 04          	mov    %edx,0x4(%esp)
 80489ca:	89 04 24             	mov    %eax,(%esp)
 80489cd:	e8 5d ff ff ff       	call   804892f <swap_byte>
 80489d2:	ff 45 fc             	incl   -0x4(%ebp)
 80489d5:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
 80489dc:	7e b6                	jle    8048994 <random_init+0x3d>
 80489de:	c6 05 41 cf 04 08 00 	movb   $0x0,0x804cf41
 80489e5:	0f b6 05 41 cf 04 08 	movzbl 0x804cf41,%eax
 80489ec:	a2 40 cf 04 08       	mov    %al,0x804cf40
 80489f1:	c6 05 42 cf 04 08 01 	movb   $0x1,0x804cf42
 80489f8:	90                   	nop
 80489f9:	89 ec                	mov    %ebp,%esp
 80489fb:	5d                   	pop    %ebp
 80489fc:	c3                   	ret    

080489fd <random_bytes>:
 80489fd:	55                   	push   %ebp
 80489fe:	89 e5                	mov    %esp,%ebp
 8048a00:	83 ec 18             	sub    $0x18,%esp
 8048a03:	0f b6 05 42 cf 04 08 	movzbl 0x804cf42,%eax
 8048a0a:	34 01                	xor    $0x1,%al
 8048a0c:	84 c0                	test   %al,%al
 8048a0e:	74 0c                	je     8048a1c <random_bytes+0x1f>
 8048a10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048a17:	e8 3b ff ff ff       	call   8048957 <random_init>
 8048a1c:	8b 45 08             	mov    0x8(%ebp),%eax
 8048a1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8048a22:	e9 92 00 00 00       	jmp    8048ab9 <random_bytes+0xbc>
 8048a27:	0f b6 05 40 cf 04 08 	movzbl 0x804cf40,%eax
 8048a2e:	fe c0                	inc    %al
 8048a30:	a2 40 cf 04 08       	mov    %al,0x804cf40
 8048a35:	0f b6 05 40 cf 04 08 	movzbl 0x804cf40,%eax
 8048a3c:	0f b6 c0             	movzbl %al,%eax
 8048a3f:	0f b6 90 40 ce 04 08 	movzbl 0x804ce40(%eax),%edx
 8048a46:	0f b6 05 41 cf 04 08 	movzbl 0x804cf41,%eax
 8048a4d:	00 d0                	add    %dl,%al
 8048a4f:	a2 41 cf 04 08       	mov    %al,0x804cf41
 8048a54:	0f b6 05 41 cf 04 08 	movzbl 0x804cf41,%eax
 8048a5b:	0f b6 c0             	movzbl %al,%eax
 8048a5e:	8d 90 40 ce 04 08    	lea    0x804ce40(%eax),%edx
 8048a64:	0f b6 05 40 cf 04 08 	movzbl 0x804cf40,%eax
 8048a6b:	0f b6 c0             	movzbl %al,%eax
 8048a6e:	05 40 ce 04 08       	add    $0x804ce40,%eax
 8048a73:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048a77:	89 04 24             	mov    %eax,(%esp)
 8048a7a:	e8 b0 fe ff ff       	call   804892f <swap_byte>
 8048a7f:	0f b6 05 40 cf 04 08 	movzbl 0x804cf40,%eax
 8048a86:	0f b6 c0             	movzbl %al,%eax
 8048a89:	0f b6 90 40 ce 04 08 	movzbl 0x804ce40(%eax),%edx
 8048a90:	0f b6 05 41 cf 04 08 	movzbl 0x804cf41,%eax
 8048a97:	0f b6 c0             	movzbl %al,%eax
 8048a9a:	0f b6 80 40 ce 04 08 	movzbl 0x804ce40(%eax),%eax
 8048aa1:	00 d0                	add    %dl,%al
 8048aa3:	88 45 fb             	mov    %al,-0x5(%ebp)
 8048aa6:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
 8048aaa:	0f b6 90 40 ce 04 08 	movzbl 0x804ce40(%eax),%edx
 8048ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048ab4:	88 10                	mov    %dl,(%eax)
 8048ab6:	ff 45 fc             	incl   -0x4(%ebp)
 8048ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048abc:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048abf:	89 55 0c             	mov    %edx,0xc(%ebp)
 8048ac2:	85 c0                	test   %eax,%eax
 8048ac4:	0f 85 5d ff ff ff    	jne    8048a27 <random_bytes+0x2a>
 8048aca:	90                   	nop
 8048acb:	90                   	nop
 8048acc:	89 ec                	mov    %ebp,%esp
 8048ace:	5d                   	pop    %ebp
 8048acf:	c3                   	ret    

08048ad0 <random_ulong>:
 8048ad0:	55                   	push   %ebp
 8048ad1:	89 e5                	mov    %esp,%ebp
 8048ad3:	83 ec 18             	sub    $0x18,%esp
 8048ad6:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 8048add:	00 
 8048ade:	8d 45 fc             	lea    -0x4(%ebp),%eax
 8048ae1:	89 04 24             	mov    %eax,(%esp)
 8048ae4:	e8 14 ff ff ff       	call   80489fd <random_bytes>
 8048ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048aec:	89 ec                	mov    %ebp,%esp
 8048aee:	5d                   	pop    %ebp
 8048aef:	c3                   	ret    

08048af0 <isdigit>:
 8048af0:	55                   	push   %ebp
 8048af1:	89 e5                	mov    %esp,%ebp
 8048af3:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
 8048af7:	7e 0d                	jle    8048b06 <isdigit+0x16>
 8048af9:	83 7d 08 39          	cmpl   $0x39,0x8(%ebp)
 8048afd:	7f 07                	jg     8048b06 <isdigit+0x16>
 8048aff:	b8 01 00 00 00       	mov    $0x1,%eax
 8048b04:	eb 05                	jmp    8048b0b <isdigit+0x1b>
 8048b06:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b0b:	5d                   	pop    %ebp
 8048b0c:	c3                   	ret    

08048b0d <isprint>:
 8048b0d:	55                   	push   %ebp
 8048b0e:	89 e5                	mov    %esp,%ebp
 8048b10:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
 8048b14:	7e 0d                	jle    8048b23 <isprint+0x16>
 8048b16:	83 7d 08 7e          	cmpl   $0x7e,0x8(%ebp)
 8048b1a:	7f 07                	jg     8048b23 <isprint+0x16>
 8048b1c:	b8 01 00 00 00       	mov    $0x1,%eax
 8048b21:	eb 05                	jmp    8048b28 <isprint+0x1b>
 8048b23:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b28:	5d                   	pop    %ebp
 8048b29:	c3                   	ret    

08048b2a <vsnprintf>:
 8048b2a:	55                   	push   %ebp
 8048b2b:	89 e5                	mov    %esp,%ebp
 8048b2d:	83 ec 28             	sub    $0x28,%esp
 8048b30:	8b 45 08             	mov    0x8(%ebp),%eax
 8048b33:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8048b36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8048b3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8048b41:	74 06                	je     8048b49 <vsnprintf+0x1f>
 8048b43:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048b46:	48                   	dec    %eax
 8048b47:	eb 05                	jmp    8048b4e <vsnprintf+0x24>
 8048b49:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048b51:	8d 45 ec             	lea    -0x14(%ebp),%eax
 8048b54:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048b58:	c7 44 24 08 85 8b 04 	movl   $0x8048b85,0x8(%esp)
 8048b5f:	08 
 8048b60:	8b 45 14             	mov    0x14(%ebp),%eax
 8048b63:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048b67:	8b 45 10             	mov    0x10(%ebp),%eax
 8048b6a:	89 04 24             	mov    %eax,(%esp)
 8048b6d:	e8 b4 00 00 00       	call   8048c26 <__vprintf>
 8048b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8048b76:	74 06                	je     8048b7e <vsnprintf+0x54>
 8048b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048b7b:	c6 00 00             	movb   $0x0,(%eax)
 8048b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048b81:	89 ec                	mov    %ebp,%esp
 8048b83:	5d                   	pop    %ebp
 8048b84:	c3                   	ret    

08048b85 <vsnprintf_helper>:
 8048b85:	55                   	push   %ebp
 8048b86:	89 e5                	mov    %esp,%ebp
 8048b88:	83 ec 14             	sub    $0x14,%esp
 8048b8b:	8b 45 08             	mov    0x8(%ebp),%eax
 8048b8e:	88 45 ec             	mov    %al,-0x14(%ebp)
 8048b91:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048b94:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8048b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048b9a:	8b 40 04             	mov    0x4(%eax),%eax
 8048b9d:	8d 48 01             	lea    0x1(%eax),%ecx
 8048ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8048ba3:	89 4a 04             	mov    %ecx,0x4(%edx)
 8048ba6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8048ba9:	8b 52 08             	mov    0x8(%edx),%edx
 8048bac:	39 d0                	cmp    %edx,%eax
 8048bae:	7d 13                	jge    8048bc3 <vsnprintf_helper+0x3e>
 8048bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048bb3:	8b 00                	mov    (%eax),%eax
 8048bb5:	8d 48 01             	lea    0x1(%eax),%ecx
 8048bb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8048bbb:	89 0a                	mov    %ecx,(%edx)
 8048bbd:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
 8048bc1:	88 10                	mov    %dl,(%eax)
 8048bc3:	90                   	nop
 8048bc4:	89 ec                	mov    %ebp,%esp
 8048bc6:	5d                   	pop    %ebp
 8048bc7:	c3                   	ret    

08048bc8 <snprintf>:
 8048bc8:	55                   	push   %ebp
 8048bc9:	89 e5                	mov    %esp,%ebp
 8048bcb:	83 ec 28             	sub    $0x28,%esp
 8048bce:	8d 45 14             	lea    0x14(%ebp),%eax
 8048bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048bd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048bdb:	8b 45 10             	mov    0x10(%ebp),%eax
 8048bde:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048be2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048be5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048be9:	8b 45 08             	mov    0x8(%ebp),%eax
 8048bec:	89 04 24             	mov    %eax,(%esp)
 8048bef:	e8 36 ff ff ff       	call   8048b2a <vsnprintf>
 8048bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048bfa:	89 ec                	mov    %ebp,%esp
 8048bfc:	5d                   	pop    %ebp
 8048bfd:	c3                   	ret    

08048bfe <printf>:
 8048bfe:	55                   	push   %ebp
 8048bff:	89 e5                	mov    %esp,%ebp
 8048c01:	83 ec 28             	sub    $0x28,%esp
 8048c04:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048c11:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c14:	89 04 24             	mov    %eax,(%esp)
 8048c17:	e8 59 24 00 00       	call   804b075 <vprintf>
 8048c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c22:	89 ec                	mov    %ebp,%esp
 8048c24:	5d                   	pop    %ebp
 8048c25:	c3                   	ret    

08048c26 <__vprintf>:
 8048c26:	55                   	push   %ebp
 8048c27:	89 e5                	mov    %esp,%ebp
 8048c29:	57                   	push   %edi
 8048c2a:	56                   	push   %esi
 8048c2b:	53                   	push   %ebx
 8048c2c:	81 ec ac 00 00 00    	sub    $0xac,%esp
 8048c32:	e9 26 07 00 00       	jmp    804935d <__vprintf+0x737>
 8048c37:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c3a:	0f b6 00             	movzbl (%eax),%eax
 8048c3d:	3c 25                	cmp    $0x25,%al
 8048c3f:	74 1d                	je     8048c5e <__vprintf+0x38>
 8048c41:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c44:	0f b6 00             	movzbl (%eax),%eax
 8048c47:	0f be d0             	movsbl %al,%edx
 8048c4a:	8b 45 14             	mov    0x14(%ebp),%eax
 8048c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048c51:	89 14 24             	mov    %edx,(%esp)
 8048c54:	8b 45 10             	mov    0x10(%ebp),%eax
 8048c57:	ff d0                	call   *%eax
 8048c59:	e9 fc 06 00 00       	jmp    804935a <__vprintf+0x734>
 8048c5e:	ff 45 08             	incl   0x8(%ebp)
 8048c61:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c64:	0f b6 00             	movzbl (%eax),%eax
 8048c67:	3c 25                	cmp    $0x25,%al
 8048c69:	75 18                	jne    8048c83 <__vprintf+0x5d>
 8048c6b:	8b 45 14             	mov    0x14(%ebp),%eax
 8048c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048c72:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
 8048c79:	8b 45 10             	mov    0x10(%ebp),%eax
 8048c7c:	ff d0                	call   *%eax
 8048c7e:	e9 d7 06 00 00       	jmp    804935a <__vprintf+0x734>
 8048c83:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048c86:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048c8a:	8d 45 98             	lea    -0x68(%ebp),%eax
 8048c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048c91:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c94:	89 04 24             	mov    %eax,(%esp)
 8048c97:	e8 dc 06 00 00       	call   8049378 <parse_conversion>
 8048c9c:	89 45 08             	mov    %eax,0x8(%ebp)
 8048c9f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048ca2:	0f b6 00             	movzbl (%eax),%eax
 8048ca5:	0f be c0             	movsbl %al,%eax
 8048ca8:	83 f8 78             	cmp    $0x78,%eax
 8048cab:	0f 8f 81 06 00 00    	jg     8049332 <__vprintf+0x70c>
 8048cb1:	83 f8 6f             	cmp    $0x6f,%eax
 8048cb4:	7d 49                	jge    8048cff <__vprintf+0xd9>
 8048cb6:	83 f8 6e             	cmp    $0x6e,%eax
 8048cb9:	0f 8f 73 06 00 00    	jg     8049332 <__vprintf+0x70c>
 8048cbf:	83 f8 64             	cmp    $0x64,%eax
 8048cc2:	7d 50                	jge    8048d14 <__vprintf+0xee>
 8048cc4:	83 f8 63             	cmp    $0x63,%eax
 8048cc7:	0f 84 03 04 00 00    	je     80490d0 <__vprintf+0x4aa>
 8048ccd:	83 f8 63             	cmp    $0x63,%eax
 8048cd0:	0f 8f 5c 06 00 00    	jg     8049332 <__vprintf+0x70c>
 8048cd6:	83 f8 58             	cmp    $0x58,%eax
 8048cd9:	0f 84 14 02 00 00    	je     8048ef3 <__vprintf+0x2cd>
 8048cdf:	83 f8 58             	cmp    $0x58,%eax
 8048ce2:	0f 8f 4a 06 00 00    	jg     8049332 <__vprintf+0x70c>
 8048ce8:	83 f8 45             	cmp    $0x45,%eax
 8048ceb:	0f 84 18 06 00 00    	je     8049309 <__vprintf+0x6e3>
 8048cf1:	83 f8 47             	cmp    $0x47,%eax
 8048cf4:	0f 84 0f 06 00 00    	je     8049309 <__vprintf+0x6e3>
 8048cfa:	e9 33 06 00 00       	jmp    8049332 <__vprintf+0x70c>
 8048cff:	83 e8 6f             	sub    $0x6f,%eax
 8048d02:	83 f8 09             	cmp    $0x9,%eax
 8048d05:	0f 87 27 06 00 00    	ja     8049332 <__vprintf+0x70c>
 8048d0b:	8b 04 85 08 b6 04 08 	mov    0x804b608(,%eax,4),%eax
 8048d12:	ff e0                	jmp    *%eax
 8048d14:	8d 50 9c             	lea    -0x64(%eax),%edx
 8048d17:	b8 01 00 00 00       	mov    $0x1,%eax
 8048d1c:	88 d1                	mov    %dl,%cl
 8048d1e:	d3 e0                	shl    %cl,%eax
 8048d20:	89 c2                	mov    %eax,%edx
 8048d22:	89 d0                	mov    %edx,%eax
 8048d24:	25 0a 04 00 00       	and    $0x40a,%eax
 8048d29:	85 c0                	test   %eax,%eax
 8048d2b:	0f 95 c0             	setne  %al
 8048d2e:	84 c0                	test   %al,%al
 8048d30:	0f 85 d3 05 00 00    	jne    8049309 <__vprintf+0x6e3>
 8048d36:	89 d0                	mov    %edx,%eax
 8048d38:	83 e0 21             	and    $0x21,%eax
 8048d3b:	85 c0                	test   %eax,%eax
 8048d3d:	0f 95 c0             	setne  %al
 8048d40:	84 c0                	test   %al,%al
 8048d42:	75 17                	jne    8048d5b <__vprintf+0x135>
 8048d44:	89 d0                	mov    %edx,%eax
 8048d46:	83 e0 04             	and    $0x4,%eax
 8048d49:	85 c0                	test   %eax,%eax
 8048d4b:	0f 95 c0             	setne  %al
 8048d4e:	84 c0                	test   %al,%al
 8048d50:	0f 85 6a 04 00 00    	jne    80491c0 <__vprintf+0x59a>
 8048d56:	e9 d7 05 00 00       	jmp    8049332 <__vprintf+0x70c>
 8048d5b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 8048d5e:	83 f8 08             	cmp    $0x8,%eax
 8048d61:	0f 87 d5 00 00 00    	ja     8048e3c <__vprintf+0x216>
 8048d67:	8b 04 85 30 b6 04 08 	mov    0x804b630(,%eax,4),%eax
 8048d6e:	ff e0                	jmp    *%eax
 8048d70:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048d73:	8d 42 04             	lea    0x4(%edx),%eax
 8048d76:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048d79:	8b 02                	mov    (%edx),%eax
 8048d7b:	0f be c0             	movsbl %al,%eax
 8048d7e:	99                   	cltd   
 8048d7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048d82:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8048d85:	e9 d7 00 00 00       	jmp    8048e61 <__vprintf+0x23b>
 8048d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048d8d:	8d 42 04             	lea    0x4(%edx),%eax
 8048d90:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048d93:	8b 02                	mov    (%edx),%eax
 8048d95:	98                   	cwtl   
 8048d96:	99                   	cltd   
 8048d97:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048d9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8048d9d:	e9 bf 00 00 00       	jmp    8048e61 <__vprintf+0x23b>
 8048da2:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048da5:	8d 42 04             	lea    0x4(%edx),%eax
 8048da8:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048dab:	8b 02                	mov    (%edx),%eax
 8048dad:	99                   	cltd   
 8048dae:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048db1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8048db4:	e9 a8 00 00 00       	jmp    8048e61 <__vprintf+0x23b>
 8048db9:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048dbc:	8d 42 08             	lea    0x8(%edx),%eax
 8048dbf:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048dc2:	8b 02                	mov    (%edx),%eax
 8048dc4:	8b 52 04             	mov    0x4(%edx),%edx
 8048dc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048dca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8048dcd:	e9 8f 00 00 00       	jmp    8048e61 <__vprintf+0x23b>
 8048dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048dd5:	8d 42 04             	lea    0x4(%edx),%eax
 8048dd8:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048ddb:	8b 02                	mov    (%edx),%eax
 8048ddd:	99                   	cltd   
 8048dde:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048de1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8048de4:	eb 7b                	jmp    8048e61 <__vprintf+0x23b>
 8048de6:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048de9:	8d 42 08             	lea    0x8(%edx),%eax
 8048dec:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048def:	8b 02                	mov    (%edx),%eax
 8048df1:	8b 52 04             	mov    0x4(%edx),%edx
 8048df4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048df7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8048dfa:	eb 65                	jmp    8048e61 <__vprintf+0x23b>
 8048dfc:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048dff:	8d 42 04             	lea    0x4(%edx),%eax
 8048e02:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048e05:	8b 02                	mov    (%edx),%eax
 8048e07:	99                   	cltd   
 8048e08:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048e0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8048e0e:	eb 51                	jmp    8048e61 <__vprintf+0x23b>
 8048e10:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048e13:	8d 42 04             	lea    0x4(%edx),%eax
 8048e16:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048e19:	8b 02                	mov    (%edx),%eax
 8048e1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048e1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 8048e25:	ba ff ff ff 7f       	mov    $0x7fffffff,%edx
 8048e2a:	b8 00 00 00 00       	mov    $0x0,%eax
 8048e2f:	3b 55 e0             	cmp    -0x20(%ebp),%edx
 8048e32:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
 8048e35:	7d 29                	jge    8048e60 <__vprintf+0x23a>
 8048e37:	ff 4d e4             	decl   -0x1c(%ebp)
 8048e3a:	eb 24                	jmp    8048e60 <__vprintf+0x23a>
 8048e3c:	c7 44 24 0c a0 b5 04 	movl   $0x804b5a0,0xc(%esp)
 8048e43:	08 
 8048e44:	c7 44 24 08 2c b7 04 	movl   $0x804b72c,0x8(%esp)
 8048e4b:	08 
 8048e4c:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
 8048e53:	00 
 8048e54:	c7 04 24 c2 b5 04 08 	movl   $0x804b5c2,(%esp)
 8048e5b:	e8 f9 1c 00 00       	call   804ab59 <debug_panic>
 8048e60:	90                   	nop
 8048e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048e64:	c1 e8 1f             	shr    $0x1f,%eax
 8048e67:	0f b6 f0             	movzbl %al,%esi
 8048e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048e6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 8048e70:	89 c3                	mov    %eax,%ebx
 8048e72:	f7 db                	neg    %ebx
 8048e74:	89 9d 78 ff ff ff    	mov    %ebx,-0x88(%ebp)
 8048e7a:	89 d3                	mov    %edx,%ebx
 8048e7c:	83 d3 00             	adc    $0x0,%ebx
 8048e7f:	89 9d 7c ff ff ff    	mov    %ebx,-0x84(%ebp)
 8048e85:	f7 9d 7c ff ff ff    	negl   -0x84(%ebp)
 8048e8b:	8b 8d 78 ff ff ff    	mov    -0x88(%ebp),%ecx
 8048e91:	8b 9d 7c ff ff ff    	mov    -0x84(%ebp),%ebx
 8048e97:	89 cf                	mov    %ecx,%edi
 8048e99:	0f 48 f8             	cmovs  %eax,%edi
 8048e9c:	89 bd 70 ff ff ff    	mov    %edi,-0x90(%ebp)
 8048ea2:	89 d0                	mov    %edx,%eax
 8048ea4:	0f 49 c3             	cmovns %ebx,%eax
 8048ea7:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 8048ead:	8b 8d 70 ff ff ff    	mov    -0x90(%ebp),%ecx
 8048eb3:	8b 9d 74 ff ff ff    	mov    -0x8c(%ebp),%ebx
 8048eb9:	8b 45 14             	mov    0x14(%ebp),%eax
 8048ebc:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 8048ec0:	8b 45 10             	mov    0x10(%ebp),%eax
 8048ec3:	89 44 24 18          	mov    %eax,0x18(%esp)
 8048ec7:	8d 45 98             	lea    -0x68(%ebp),%eax
 8048eca:	89 44 24 14          	mov    %eax,0x14(%esp)
 8048ece:	c7 44 24 10 d4 b4 04 	movl   $0x804b4d4,0x10(%esp)
 8048ed5:	08 
 8048ed6:	89 74 24 0c          	mov    %esi,0xc(%esp)
 8048eda:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8048ee1:	00 
 8048ee2:	89 0c 24             	mov    %ecx,(%esp)
 8048ee5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048ee9:	e8 4c 07 00 00       	call   804963a <format_integer>
 8048eee:	e9 67 04 00 00       	jmp    804935a <__vprintf+0x734>
 8048ef3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 8048ef6:	83 f8 08             	cmp    $0x8,%eax
 8048ef9:	0f 87 fb 00 00 00    	ja     8048ffa <__vprintf+0x3d4>
 8048eff:	8b 04 85 54 b6 04 08 	mov    0x804b654(,%eax,4),%eax
 8048f06:	ff e0                	jmp    *%eax
 8048f08:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048f0b:	8d 42 04             	lea    0x4(%edx),%eax
 8048f0e:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048f11:	8b 02                	mov    (%edx),%eax
 8048f13:	0f b6 c0             	movzbl %al,%eax
 8048f16:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048f19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 8048f20:	e9 f9 00 00 00       	jmp    804901e <__vprintf+0x3f8>
 8048f25:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048f28:	8d 42 04             	lea    0x4(%edx),%eax
 8048f2b:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048f2e:	8b 02                	mov    (%edx),%eax
 8048f30:	0f b7 c0             	movzwl %ax,%eax
 8048f33:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048f36:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 8048f3d:	e9 dc 00 00 00       	jmp    804901e <__vprintf+0x3f8>
 8048f42:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048f45:	8d 42 04             	lea    0x4(%edx),%eax
 8048f48:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048f4b:	8b 02                	mov    (%edx),%eax
 8048f4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048f50:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 8048f57:	e9 c2 00 00 00       	jmp    804901e <__vprintf+0x3f8>
 8048f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048f5f:	8d 42 08             	lea    0x8(%edx),%eax
 8048f62:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048f65:	8b 02                	mov    (%edx),%eax
 8048f67:	8b 52 04             	mov    0x4(%edx),%edx
 8048f6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048f6d:	89 55 dc             	mov    %edx,-0x24(%ebp)
 8048f70:	e9 a9 00 00 00       	jmp    804901e <__vprintf+0x3f8>
 8048f75:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048f78:	8d 42 04             	lea    0x4(%edx),%eax
 8048f7b:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048f7e:	8b 02                	mov    (%edx),%eax
 8048f80:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048f83:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 8048f8a:	e9 8f 00 00 00       	jmp    804901e <__vprintf+0x3f8>
 8048f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048f92:	8d 42 08             	lea    0x8(%edx),%eax
 8048f95:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048f98:	8b 02                	mov    (%edx),%eax
 8048f9a:	8b 52 04             	mov    0x4(%edx),%edx
 8048f9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048fa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
 8048fa3:	eb 79                	jmp    804901e <__vprintf+0x3f8>
 8048fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048fa8:	8d 42 04             	lea    0x4(%edx),%eax
 8048fab:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048fae:	8b 02                	mov    (%edx),%eax
 8048fb0:	99                   	cltd   
 8048fb1:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048fb4:	89 55 dc             	mov    %edx,-0x24(%ebp)
 8048fb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8048fba:	83 e0 ff             	and    $0xffffffff,%eax
 8048fbd:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 8048fc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048fc6:	83 e0 00             	and    $0x0,%eax
 8048fc9:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 8048fcf:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
 8048fd5:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
 8048fdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048fde:	89 55 dc             	mov    %edx,-0x24(%ebp)
 8048fe1:	eb 3b                	jmp    804901e <__vprintf+0x3f8>
 8048fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048fe6:	8d 42 04             	lea    0x4(%edx),%eax
 8048fe9:	89 45 0c             	mov    %eax,0xc(%ebp)
 8048fec:	8b 02                	mov    (%edx),%eax
 8048fee:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8048ff1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 8048ff8:	eb 24                	jmp    804901e <__vprintf+0x3f8>
 8048ffa:	c7 44 24 0c a0 b5 04 	movl   $0x804b5a0,0xc(%esp)
 8049001:	08 
 8049002:	c7 44 24 08 2c b7 04 	movl   $0x804b72c,0x8(%esp)
 8049009:	08 
 804900a:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
 8049011:	00 
 8049012:	c7 04 24 c2 b5 04 08 	movl   $0x804b5c2,(%esp)
 8049019:	e8 3b 1b 00 00       	call   804ab59 <debug_panic>
 804901e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049021:	0f b6 00             	movzbl (%eax),%eax
 8049024:	0f be c0             	movsbl %al,%eax
 8049027:	83 f8 78             	cmp    $0x78,%eax
 804902a:	74 2b                	je     8049057 <__vprintf+0x431>
 804902c:	83 f8 78             	cmp    $0x78,%eax
 804902f:	7f 38                	jg     8049069 <__vprintf+0x443>
 8049031:	83 f8 75             	cmp    $0x75,%eax
 8049034:	74 18                	je     804904e <__vprintf+0x428>
 8049036:	83 f8 75             	cmp    $0x75,%eax
 8049039:	7f 2e                	jg     8049069 <__vprintf+0x443>
 804903b:	83 f8 58             	cmp    $0x58,%eax
 804903e:	74 20                	je     8049060 <__vprintf+0x43a>
 8049040:	83 f8 6f             	cmp    $0x6f,%eax
 8049043:	75 24                	jne    8049069 <__vprintf+0x443>
 8049045:	c7 45 d4 f0 b4 04 08 	movl   $0x804b4f0,-0x2c(%ebp)
 804904c:	eb 3f                	jmp    804908d <__vprintf+0x467>
 804904e:	c7 45 d4 d4 b4 04 08 	movl   $0x804b4d4,-0x2c(%ebp)
 8049055:	eb 36                	jmp    804908d <__vprintf+0x467>
 8049057:	c7 45 d4 14 b5 04 08 	movl   $0x804b514,-0x2c(%ebp)
 804905e:	eb 2d                	jmp    804908d <__vprintf+0x467>
 8049060:	c7 45 d4 38 b5 04 08 	movl   $0x804b538,-0x2c(%ebp)
 8049067:	eb 24                	jmp    804908d <__vprintf+0x467>
 8049069:	c7 44 24 0c a0 b5 04 	movl   $0x804b5a0,0xc(%esp)
 8049070:	08 
 8049071:	c7 44 24 08 2c b7 04 	movl   $0x804b72c,0x8(%esp)
 8049078:	08 
 8049079:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
 8049080:	00 
 8049081:	c7 04 24 c2 b5 04 08 	movl   $0x804b5c2,(%esp)
 8049088:	e8 cc 1a 00 00       	call   804ab59 <debug_panic>
 804908d:	8b 45 14             	mov    0x14(%ebp),%eax
 8049090:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 8049094:	8b 45 10             	mov    0x10(%ebp),%eax
 8049097:	89 44 24 18          	mov    %eax,0x18(%esp)
 804909b:	8d 45 98             	lea    -0x68(%ebp),%eax
 804909e:	89 44 24 14          	mov    %eax,0x14(%esp)
 80490a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 80490a5:	89 44 24 10          	mov    %eax,0x10(%esp)
 80490a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 80490b0:	00 
 80490b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 80490b8:	00 
 80490b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80490bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
 80490bf:	89 04 24             	mov    %eax,(%esp)
 80490c2:	89 54 24 04          	mov    %edx,0x4(%esp)
 80490c6:	e8 6f 05 00 00       	call   804963a <format_integer>
 80490cb:	e9 8a 02 00 00       	jmp    804935a <__vprintf+0x734>
 80490d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 80490d3:	8d 42 04             	lea    0x4(%edx),%eax
 80490d6:	89 45 0c             	mov    %eax,0xc(%ebp)
 80490d9:	8b 02                	mov    (%edx),%eax
 80490db:	88 45 97             	mov    %al,-0x69(%ebp)
 80490de:	8b 45 14             	mov    0x14(%ebp),%eax
 80490e1:	89 44 24 10          	mov    %eax,0x10(%esp)
 80490e5:	8b 45 10             	mov    0x10(%ebp),%eax
 80490e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 80490ec:	8d 45 98             	lea    -0x68(%ebp),%eax
 80490ef:	89 44 24 08          	mov    %eax,0x8(%esp)
 80490f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 80490fa:	00 
 80490fb:	8d 45 97             	lea    -0x69(%ebp),%eax
 80490fe:	89 04 24             	mov    %eax,(%esp)
 8049101:	e8 c7 08 00 00       	call   80499cd <format_string>
 8049106:	e9 4f 02 00 00       	jmp    804935a <__vprintf+0x734>
 804910b:	8b 55 0c             	mov    0xc(%ebp),%edx
 804910e:	8d 42 04             	lea    0x4(%edx),%eax
 8049111:	89 45 0c             	mov    %eax,0xc(%ebp)
 8049114:	8b 02                	mov    (%edx),%eax
 8049116:	89 45 d0             	mov    %eax,-0x30(%ebp)
 8049119:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 804911d:	75 07                	jne    8049126 <__vprintf+0x500>
 804911f:	c7 45 d0 d4 b5 04 08 	movl   $0x804b5d4,-0x30(%ebp)
 8049126:	8b 45 a0             	mov    -0x60(%ebp),%eax
 8049129:	89 44 24 04          	mov    %eax,0x4(%esp)
 804912d:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8049130:	89 04 24             	mov    %eax,(%esp)
 8049133:	e8 6a 13 00 00       	call   804a4a2 <strnlen>
 8049138:	89 c2                	mov    %eax,%edx
 804913a:	8b 45 14             	mov    0x14(%ebp),%eax
 804913d:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049141:	8b 45 10             	mov    0x10(%ebp),%eax
 8049144:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049148:	8d 45 98             	lea    -0x68(%ebp),%eax
 804914b:	89 44 24 08          	mov    %eax,0x8(%esp)
 804914f:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049153:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8049156:	89 04 24             	mov    %eax,(%esp)
 8049159:	e8 6f 08 00 00       	call   80499cd <format_string>
 804915e:	e9 f7 01 00 00       	jmp    804935a <__vprintf+0x734>
 8049163:	8b 55 0c             	mov    0xc(%ebp),%edx
 8049166:	8d 42 04             	lea    0x4(%edx),%eax
 8049169:	89 45 0c             	mov    %eax,0xc(%ebp)
 804916c:	8b 02                	mov    (%edx),%eax
 804916e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 8049171:	c7 45 98 08 00 00 00 	movl   $0x8,-0x68(%ebp)
 8049178:	8b 45 cc             	mov    -0x34(%ebp),%eax
 804917b:	89 c1                	mov    %eax,%ecx
 804917d:	bb 00 00 00 00       	mov    $0x0,%ebx
 8049182:	8b 45 14             	mov    0x14(%ebp),%eax
 8049185:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 8049189:	8b 45 10             	mov    0x10(%ebp),%eax
 804918c:	89 44 24 18          	mov    %eax,0x18(%esp)
 8049190:	8d 45 98             	lea    -0x68(%ebp),%eax
 8049193:	89 44 24 14          	mov    %eax,0x14(%esp)
 8049197:	c7 44 24 10 14 b5 04 	movl   $0x804b514,0x10(%esp)
 804919e:	08 
 804919f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 80491a6:	00 
 80491a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 80491ae:	00 
 80491af:	89 0c 24             	mov    %ecx,(%esp)
 80491b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 80491b6:	e8 7f 04 00 00       	call   804963a <format_integer>
 80491bb:	e9 9a 01 00 00       	jmp    804935a <__vprintf+0x734>
 80491c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
 80491c3:	85 c0                	test   %eax,%eax
 80491c5:	79 08                	jns    80491cf <__vprintf+0x5a9>
 80491c7:	b8 06 00 00 00       	mov    $0x6,%eax
 80491cc:	89 45 a0             	mov    %eax,-0x60(%ebp)
 80491cf:	8b 55 a0             	mov    -0x60(%ebp),%edx
 80491d2:	b8 09 00 00 00       	mov    $0x9,%eax
 80491d7:	39 c2                	cmp    %eax,%edx
 80491d9:	7e 08                	jle    80491e3 <__vprintf+0x5bd>
 80491db:	b8 09 00 00 00       	mov    $0x9,%eax
 80491e0:	89 45 a0             	mov    %eax,-0x60(%ebp)
 80491e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 80491e6:	8d 42 08             	lea    0x8(%edx),%eax
 80491e9:	89 45 0c             	mov    %eax,0xc(%ebp)
 80491ec:	dd 02                	fldl   (%edx)
 80491ee:	dd 5d c0             	fstpl  -0x40(%ebp)
 80491f1:	dd 45 c0             	fldl   -0x40(%ebp)
 80491f4:	d9 7d 86             	fnstcw -0x7a(%ebp)
 80491f7:	0f b7 45 86          	movzwl -0x7a(%ebp),%eax
 80491fb:	66 0d 00 0c          	or     $0xc00,%ax
 80491ff:	66 89 45 84          	mov    %ax,-0x7c(%ebp)
 8049203:	d9 6d 84             	fldcw  -0x7c(%ebp)
 8049206:	db 5d bc             	fistpl -0x44(%ebp)
 8049209:	d9 6d 86             	fldcw  -0x7a(%ebp)
 804920c:	db 45 bc             	fildl  -0x44(%ebp)
 804920f:	dd 45 c0             	fldl   -0x40(%ebp)
 8049212:	de e1                	fsubp  %st,%st(1)
 8049214:	8b 45 a0             	mov    -0x60(%ebp),%eax
 8049217:	8b 04 85 60 b5 04 08 	mov    0x804b560(,%eax,4),%eax
 804921e:	89 45 80             	mov    %eax,-0x80(%ebp)
 8049221:	db 45 80             	fildl  -0x80(%ebp)
 8049224:	de c9                	fmulp  %st,%st(1)
 8049226:	dd 5d b0             	fstpl  -0x50(%ebp)
 8049229:	dd 45 b0             	fldl   -0x50(%ebp)
 804922c:	d9 6d 84             	fldcw  -0x7c(%ebp)
 804922f:	db 5d ac             	fistpl -0x54(%ebp)
 8049232:	d9 6d 86             	fldcw  -0x7a(%ebp)
 8049235:	8b 45 a0             	mov    -0x60(%ebp),%eax
 8049238:	89 45 a8             	mov    %eax,-0x58(%ebp)
 804923b:	c7 45 a0 ff ff ff ff 	movl   $0xffffffff,-0x60(%ebp)
 8049242:	dd 45 c0             	fldl   -0x40(%ebp)
 8049245:	d9 ee                	fldz   
 8049247:	df f1                	fcomip %st(1),%st
 8049249:	dd d8                	fstp   %st(0)
 804924b:	0f 97 c0             	seta   %al
 804924e:	0f b6 f0             	movzbl %al,%esi
 8049251:	8b 45 bc             	mov    -0x44(%ebp),%eax
 8049254:	89 c2                	mov    %eax,%edx
 8049256:	f7 da                	neg    %edx
 8049258:	0f 49 c2             	cmovns %edx,%eax
 804925b:	89 c1                	mov    %eax,%ecx
 804925d:	89 c3                	mov    %eax,%ebx
 804925f:	c1 fb 1f             	sar    $0x1f,%ebx
 8049262:	8b 45 14             	mov    0x14(%ebp),%eax
 8049265:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 8049269:	8b 45 10             	mov    0x10(%ebp),%eax
 804926c:	89 44 24 18          	mov    %eax,0x18(%esp)
 8049270:	8d 45 98             	lea    -0x68(%ebp),%eax
 8049273:	89 44 24 14          	mov    %eax,0x14(%esp)
 8049277:	c7 44 24 10 d4 b4 04 	movl   $0x804b4d4,0x10(%esp)
 804927e:	08 
 804927f:	89 74 24 0c          	mov    %esi,0xc(%esp)
 8049283:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 804928a:	00 
 804928b:	89 0c 24             	mov    %ecx,(%esp)
 804928e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8049292:	e8 a3 03 00 00       	call   804963a <format_integer>
 8049297:	8b 45 14             	mov    0x14(%ebp),%eax
 804929a:	89 44 24 04          	mov    %eax,0x4(%esp)
 804929e:	c7 04 24 2e 00 00 00 	movl   $0x2e,(%esp)
 80492a5:	8b 45 10             	mov    0x10(%ebp),%eax
 80492a8:	ff d0                	call   *%eax
 80492aa:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
 80492ae:	74 05                	je     80492b5 <__vprintf+0x68f>
 80492b0:	8b 45 a8             	mov    -0x58(%ebp),%eax
 80492b3:	eb 05                	jmp    80492ba <__vprintf+0x694>
 80492b5:	b8 01 00 00 00       	mov    $0x1,%eax
 80492ba:	89 45 a0             	mov    %eax,-0x60(%ebp)
 80492bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
 80492c0:	89 c2                	mov    %eax,%edx
 80492c2:	f7 da                	neg    %edx
 80492c4:	0f 49 c2             	cmovns %edx,%eax
 80492c7:	89 c1                	mov    %eax,%ecx
 80492c9:	89 c3                	mov    %eax,%ebx
 80492cb:	c1 fb 1f             	sar    $0x1f,%ebx
 80492ce:	8b 45 14             	mov    0x14(%ebp),%eax
 80492d1:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 80492d5:	8b 45 10             	mov    0x10(%ebp),%eax
 80492d8:	89 44 24 18          	mov    %eax,0x18(%esp)
 80492dc:	8d 45 98             	lea    -0x68(%ebp),%eax
 80492df:	89 44 24 14          	mov    %eax,0x14(%esp)
 80492e3:	c7 44 24 10 d4 b4 04 	movl   $0x804b4d4,0x10(%esp)
 80492ea:	08 
 80492eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 80492f2:	00 
 80492f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 80492fa:	00 
 80492fb:	89 0c 24             	mov    %ecx,(%esp)
 80492fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8049302:	e8 33 03 00 00       	call   804963a <format_integer>
 8049307:	eb 51                	jmp    804935a <__vprintf+0x734>
 8049309:	8b 45 08             	mov    0x8(%ebp),%eax
 804930c:	0f b6 00             	movzbl (%eax),%eax
 804930f:	0f be c0             	movsbl %al,%eax
 8049312:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049316:	8b 45 14             	mov    0x14(%ebp),%eax
 8049319:	89 44 24 08          	mov    %eax,0x8(%esp)
 804931d:	8b 45 10             	mov    0x10(%ebp),%eax
 8049320:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049324:	c7 04 24 db b5 04 08 	movl   $0x804b5db,(%esp)
 804932b:	e8 59 07 00 00       	call   8049a89 <__printf>
 8049330:	eb 28                	jmp    804935a <__vprintf+0x734>
 8049332:	8b 45 08             	mov    0x8(%ebp),%eax
 8049335:	0f b6 00             	movzbl (%eax),%eax
 8049338:	0f be c0             	movsbl %al,%eax
 804933b:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804933f:	8b 45 14             	mov    0x14(%ebp),%eax
 8049342:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049346:	8b 45 10             	mov    0x10(%ebp),%eax
 8049349:	89 44 24 04          	mov    %eax,0x4(%esp)
 804934d:	c7 04 24 f1 b5 04 08 	movl   $0x804b5f1,(%esp)
 8049354:	e8 30 07 00 00       	call   8049a89 <__printf>
 8049359:	90                   	nop
 804935a:	ff 45 08             	incl   0x8(%ebp)
 804935d:	8b 45 08             	mov    0x8(%ebp),%eax
 8049360:	0f b6 00             	movzbl (%eax),%eax
 8049363:	84 c0                	test   %al,%al
 8049365:	0f 85 cc f8 ff ff    	jne    8048c37 <__vprintf+0x11>
 804936b:	90                   	nop
 804936c:	90                   	nop
 804936d:	81 c4 ac 00 00 00    	add    $0xac,%esp
 8049373:	5b                   	pop    %ebx
 8049374:	5e                   	pop    %esi
 8049375:	5f                   	pop    %edi
 8049376:	5d                   	pop    %ebp
 8049377:	c3                   	ret    

08049378 <parse_conversion>:
 8049378:	55                   	push   %ebp
 8049379:	89 e5                	mov    %esp,%ebp
 804937b:	83 ec 04             	sub    $0x4,%esp
 804937e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 8049387:	8b 45 08             	mov    0x8(%ebp),%eax
 804938a:	8d 50 01             	lea    0x1(%eax),%edx
 804938d:	89 55 08             	mov    %edx,0x8(%ebp)
 8049390:	0f b6 00             	movzbl (%eax),%eax
 8049393:	0f be c0             	movsbl %al,%eax
 8049396:	83 e8 20             	sub    $0x20,%eax
 8049399:	83 f8 10             	cmp    $0x10,%eax
 804939c:	77 6f                	ja     804940d <parse_conversion+0x95>
 804939e:	8b 04 85 78 b6 04 08 	mov    0x804b678(,%eax,4),%eax
 80493a5:	ff e0                	jmp    *%eax
 80493a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493aa:	8b 00                	mov    (%eax),%eax
 80493ac:	83 c8 01             	or     $0x1,%eax
 80493af:	89 c2                	mov    %eax,%edx
 80493b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493b4:	89 10                	mov    %edx,(%eax)
 80493b6:	eb 67                	jmp    804941f <parse_conversion+0xa7>
 80493b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493bb:	8b 00                	mov    (%eax),%eax
 80493bd:	83 c8 02             	or     $0x2,%eax
 80493c0:	89 c2                	mov    %eax,%edx
 80493c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493c5:	89 10                	mov    %edx,(%eax)
 80493c7:	eb 56                	jmp    804941f <parse_conversion+0xa7>
 80493c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493cc:	8b 00                	mov    (%eax),%eax
 80493ce:	83 c8 04             	or     $0x4,%eax
 80493d1:	89 c2                	mov    %eax,%edx
 80493d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493d6:	89 10                	mov    %edx,(%eax)
 80493d8:	eb 45                	jmp    804941f <parse_conversion+0xa7>
 80493da:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493dd:	8b 00                	mov    (%eax),%eax
 80493df:	83 c8 08             	or     $0x8,%eax
 80493e2:	89 c2                	mov    %eax,%edx
 80493e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493e7:	89 10                	mov    %edx,(%eax)
 80493e9:	eb 34                	jmp    804941f <parse_conversion+0xa7>
 80493eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493ee:	8b 00                	mov    (%eax),%eax
 80493f0:	83 c8 10             	or     $0x10,%eax
 80493f3:	89 c2                	mov    %eax,%edx
 80493f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493f8:	89 10                	mov    %edx,(%eax)
 80493fa:	eb 23                	jmp    804941f <parse_conversion+0xa7>
 80493fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 80493ff:	8b 00                	mov    (%eax),%eax
 8049401:	83 c8 20             	or     $0x20,%eax
 8049404:	89 c2                	mov    %eax,%edx
 8049406:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049409:	89 10                	mov    %edx,(%eax)
 804940b:	eb 12                	jmp    804941f <parse_conversion+0xa7>
 804940d:	ff 4d 08             	decl   0x8(%ebp)
 8049410:	90                   	nop
 8049411:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049414:	8b 00                	mov    (%eax),%eax
 8049416:	83 e0 01             	and    $0x1,%eax
 8049419:	85 c0                	test   %eax,%eax
 804941b:	74 16                	je     8049433 <parse_conversion+0xbb>
 804941d:	eb 05                	jmp    8049424 <parse_conversion+0xac>
 804941f:	e9 63 ff ff ff       	jmp    8049387 <parse_conversion+0xf>
 8049424:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049427:	8b 00                	mov    (%eax),%eax
 8049429:	83 e0 ef             	and    $0xffffffef,%eax
 804942c:	89 c2                	mov    %eax,%edx
 804942e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049431:	89 10                	mov    %edx,(%eax)
 8049433:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049436:	8b 00                	mov    (%eax),%eax
 8049438:	83 e0 02             	and    $0x2,%eax
 804943b:	85 c0                	test   %eax,%eax
 804943d:	74 0f                	je     804944e <parse_conversion+0xd6>
 804943f:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049442:	8b 00                	mov    (%eax),%eax
 8049444:	83 e0 fb             	and    $0xfffffffb,%eax
 8049447:	89 c2                	mov    %eax,%edx
 8049449:	8b 45 0c             	mov    0xc(%ebp),%eax
 804944c:	89 10                	mov    %edx,(%eax)
 804944e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049451:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 8049458:	8b 45 08             	mov    0x8(%ebp),%eax
 804945b:	0f b6 00             	movzbl (%eax),%eax
 804945e:	3c 2a                	cmp    $0x2a,%al
 8049460:	75 42                	jne    80494a4 <parse_conversion+0x12c>
 8049462:	ff 45 08             	incl   0x8(%ebp)
 8049465:	8b 45 10             	mov    0x10(%ebp),%eax
 8049468:	8b 00                	mov    (%eax),%eax
 804946a:	8d 48 04             	lea    0x4(%eax),%ecx
 804946d:	8b 55 10             	mov    0x10(%ebp),%edx
 8049470:	89 0a                	mov    %ecx,(%edx)
 8049472:	8b 10                	mov    (%eax),%edx
 8049474:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049477:	89 50 04             	mov    %edx,0x4(%eax)
 804947a:	eb 3d                	jmp    80494b9 <parse_conversion+0x141>
 804947c:	8b 45 0c             	mov    0xc(%ebp),%eax
 804947f:	8b 50 04             	mov    0x4(%eax),%edx
 8049482:	89 d0                	mov    %edx,%eax
 8049484:	c1 e0 02             	shl    $0x2,%eax
 8049487:	01 d0                	add    %edx,%eax
 8049489:	01 c0                	add    %eax,%eax
 804948b:	89 c2                	mov    %eax,%edx
 804948d:	8b 45 08             	mov    0x8(%ebp),%eax
 8049490:	0f b6 00             	movzbl (%eax),%eax
 8049493:	0f be c0             	movsbl %al,%eax
 8049496:	01 d0                	add    %edx,%eax
 8049498:	8d 50 d0             	lea    -0x30(%eax),%edx
 804949b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804949e:	89 50 04             	mov    %edx,0x4(%eax)
 80494a1:	ff 45 08             	incl   0x8(%ebp)
 80494a4:	8b 45 08             	mov    0x8(%ebp),%eax
 80494a7:	0f b6 00             	movzbl (%eax),%eax
 80494aa:	0f be c0             	movsbl %al,%eax
 80494ad:	89 04 24             	mov    %eax,(%esp)
 80494b0:	e8 3b f6 ff ff       	call   8048af0 <isdigit>
 80494b5:	85 c0                	test   %eax,%eax
 80494b7:	75 c3                	jne    804947c <parse_conversion+0x104>
 80494b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494bc:	8b 40 04             	mov    0x4(%eax),%eax
 80494bf:	85 c0                	test   %eax,%eax
 80494c1:	79 1f                	jns    80494e2 <parse_conversion+0x16a>
 80494c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494c6:	8b 40 04             	mov    0x4(%eax),%eax
 80494c9:	f7 d8                	neg    %eax
 80494cb:	89 c2                	mov    %eax,%edx
 80494cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494d0:	89 50 04             	mov    %edx,0x4(%eax)
 80494d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494d6:	8b 00                	mov    (%eax),%eax
 80494d8:	83 c8 01             	or     $0x1,%eax
 80494db:	89 c2                	mov    %eax,%edx
 80494dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494e0:	89 10                	mov    %edx,(%eax)
 80494e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494e5:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
 80494ec:	8b 45 08             	mov    0x8(%ebp),%eax
 80494ef:	0f b6 00             	movzbl (%eax),%eax
 80494f2:	3c 2e                	cmp    $0x2e,%al
 80494f4:	0f 85 84 00 00 00    	jne    804957e <parse_conversion+0x206>
 80494fa:	ff 45 08             	incl   0x8(%ebp)
 80494fd:	8b 45 08             	mov    0x8(%ebp),%eax
 8049500:	0f b6 00             	movzbl (%eax),%eax
 8049503:	3c 2a                	cmp    $0x2a,%al
 8049505:	75 1a                	jne    8049521 <parse_conversion+0x1a9>
 8049507:	ff 45 08             	incl   0x8(%ebp)
 804950a:	8b 45 10             	mov    0x10(%ebp),%eax
 804950d:	8b 00                	mov    (%eax),%eax
 804950f:	8d 48 04             	lea    0x4(%eax),%ecx
 8049512:	8b 55 10             	mov    0x10(%ebp),%edx
 8049515:	89 0a                	mov    %ecx,(%edx)
 8049517:	8b 10                	mov    (%eax),%edx
 8049519:	8b 45 0c             	mov    0xc(%ebp),%eax
 804951c:	89 50 08             	mov    %edx,0x8(%eax)
 804951f:	eb 49                	jmp    804956a <parse_conversion+0x1f2>
 8049521:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049524:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
 804952b:	eb 28                	jmp    8049555 <parse_conversion+0x1dd>
 804952d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049530:	8b 50 08             	mov    0x8(%eax),%edx
 8049533:	89 d0                	mov    %edx,%eax
 8049535:	c1 e0 02             	shl    $0x2,%eax
 8049538:	01 d0                	add    %edx,%eax
 804953a:	01 c0                	add    %eax,%eax
 804953c:	89 c2                	mov    %eax,%edx
 804953e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049541:	0f b6 00             	movzbl (%eax),%eax
 8049544:	0f be c0             	movsbl %al,%eax
 8049547:	01 d0                	add    %edx,%eax
 8049549:	8d 50 d0             	lea    -0x30(%eax),%edx
 804954c:	8b 45 0c             	mov    0xc(%ebp),%eax
 804954f:	89 50 08             	mov    %edx,0x8(%eax)
 8049552:	ff 45 08             	incl   0x8(%ebp)
 8049555:	8b 45 08             	mov    0x8(%ebp),%eax
 8049558:	0f b6 00             	movzbl (%eax),%eax
 804955b:	0f be c0             	movsbl %al,%eax
 804955e:	89 04 24             	mov    %eax,(%esp)
 8049561:	e8 8a f5 ff ff       	call   8048af0 <isdigit>
 8049566:	85 c0                	test   %eax,%eax
 8049568:	75 c3                	jne    804952d <parse_conversion+0x1b5>
 804956a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804956d:	8b 40 08             	mov    0x8(%eax),%eax
 8049570:	85 c0                	test   %eax,%eax
 8049572:	79 0a                	jns    804957e <parse_conversion+0x206>
 8049574:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049577:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
 804957e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049581:	8b 40 08             	mov    0x8(%eax),%eax
 8049584:	85 c0                	test   %eax,%eax
 8049586:	78 0f                	js     8049597 <parse_conversion+0x21f>
 8049588:	8b 45 0c             	mov    0xc(%ebp),%eax
 804958b:	8b 00                	mov    (%eax),%eax
 804958d:	83 e0 ef             	and    $0xffffffef,%eax
 8049590:	89 c2                	mov    %eax,%edx
 8049592:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049595:	89 10                	mov    %edx,(%eax)
 8049597:	8b 45 0c             	mov    0xc(%ebp),%eax
 804959a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
 80495a1:	8b 45 08             	mov    0x8(%ebp),%eax
 80495a4:	8d 50 01             	lea    0x1(%eax),%edx
 80495a7:	89 55 08             	mov    %edx,0x8(%ebp)
 80495aa:	0f b6 00             	movzbl (%eax),%eax
 80495ad:	0f be c0             	movsbl %al,%eax
 80495b0:	83 e8 68             	sub    $0x68,%eax
 80495b3:	83 f8 12             	cmp    $0x12,%eax
 80495b6:	77 77                	ja     804962f <parse_conversion+0x2b7>
 80495b8:	8b 04 85 bc b6 04 08 	mov    0x804b6bc(,%eax,4),%eax
 80495bf:	ff e0                	jmp    *%eax
 80495c1:	8b 45 08             	mov    0x8(%ebp),%eax
 80495c4:	0f b6 00             	movzbl (%eax),%eax
 80495c7:	3c 68                	cmp    $0x68,%al
 80495c9:	75 0f                	jne    80495da <parse_conversion+0x262>
 80495cb:	ff 45 08             	incl   0x8(%ebp)
 80495ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 80495d1:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
 80495d8:	eb 59                	jmp    8049633 <parse_conversion+0x2bb>
 80495da:	8b 45 0c             	mov    0xc(%ebp),%eax
 80495dd:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
 80495e4:	eb 4d                	jmp    8049633 <parse_conversion+0x2bb>
 80495e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 80495e9:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
 80495f0:	eb 41                	jmp    8049633 <parse_conversion+0x2bb>
 80495f2:	8b 45 08             	mov    0x8(%ebp),%eax
 80495f5:	0f b6 00             	movzbl (%eax),%eax
 80495f8:	3c 6c                	cmp    $0x6c,%al
 80495fa:	75 0f                	jne    804960b <parse_conversion+0x293>
 80495fc:	ff 45 08             	incl   0x8(%ebp)
 80495ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049602:	c7 40 0c 06 00 00 00 	movl   $0x6,0xc(%eax)
 8049609:	eb 28                	jmp    8049633 <parse_conversion+0x2bb>
 804960b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804960e:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
 8049615:	eb 1c                	jmp    8049633 <parse_conversion+0x2bb>
 8049617:	8b 45 0c             	mov    0xc(%ebp),%eax
 804961a:	c7 40 0c 07 00 00 00 	movl   $0x7,0xc(%eax)
 8049621:	eb 10                	jmp    8049633 <parse_conversion+0x2bb>
 8049623:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049626:	c7 40 0c 08 00 00 00 	movl   $0x8,0xc(%eax)
 804962d:	eb 04                	jmp    8049633 <parse_conversion+0x2bb>
 804962f:	ff 4d 08             	decl   0x8(%ebp)
 8049632:	90                   	nop
 8049633:	8b 45 08             	mov    0x8(%ebp),%eax
 8049636:	89 ec                	mov    %ebp,%esp
 8049638:	5d                   	pop    %ebp
 8049639:	c3                   	ret    

0804963a <format_integer>:
 804963a:	55                   	push   %ebp
 804963b:	89 e5                	mov    %esp,%ebp
 804963d:	57                   	push   %edi
 804963e:	56                   	push   %esi
 804963f:	53                   	push   %ebx
 8049640:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
 8049646:	8b 45 10             	mov    0x10(%ebp),%eax
 8049649:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 804964f:	8b 55 14             	mov    0x14(%ebp),%edx
 8049652:	8b 45 08             	mov    0x8(%ebp),%eax
 8049655:	89 45 80             	mov    %eax,-0x80(%ebp)
 8049658:	8b 45 0c             	mov    0xc(%ebp),%eax
 804965b:	89 45 84             	mov    %eax,-0x7c(%ebp)
 804965e:	0f b6 85 74 ff ff ff 	movzbl -0x8c(%ebp),%eax
 8049665:	88 85 7c ff ff ff    	mov    %al,-0x84(%ebp)
 804966b:	88 d0                	mov    %dl,%al
 804966d:	88 85 78 ff ff ff    	mov    %al,-0x88(%ebp)
 8049673:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 804967a:	80 bd 7c ff ff ff 00 	cmpb   $0x0,-0x84(%ebp)
 8049681:	74 5c                	je     80496df <format_integer+0xa5>
 8049683:	8b 45 1c             	mov    0x1c(%ebp),%eax
 8049686:	8b 00                	mov    (%eax),%eax
 8049688:	83 e0 02             	and    $0x2,%eax
 804968b:	85 c0                	test   %eax,%eax
 804968d:	74 1a                	je     80496a9 <format_integer+0x6f>
 804968f:	80 bd 78 ff ff ff 00 	cmpb   $0x0,-0x88(%ebp)
 8049696:	74 07                	je     804969f <format_integer+0x65>
 8049698:	b8 2d 00 00 00       	mov    $0x2d,%eax
 804969d:	eb 05                	jmp    80496a4 <format_integer+0x6a>
 804969f:	b8 2b 00 00 00       	mov    $0x2b,%eax
 80496a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 80496a7:	eb 36                	jmp    80496df <format_integer+0xa5>
 80496a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
 80496ac:	8b 00                	mov    (%eax),%eax
 80496ae:	83 e0 04             	and    $0x4,%eax
 80496b1:	85 c0                	test   %eax,%eax
 80496b3:	74 1a                	je     80496cf <format_integer+0x95>
 80496b5:	80 bd 78 ff ff ff 00 	cmpb   $0x0,-0x88(%ebp)
 80496bc:	74 07                	je     80496c5 <format_integer+0x8b>
 80496be:	b8 2d 00 00 00       	mov    $0x2d,%eax
 80496c3:	eb 05                	jmp    80496ca <format_integer+0x90>
 80496c5:	b8 20 00 00 00       	mov    $0x20,%eax
 80496ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
 80496cd:	eb 10                	jmp    80496df <format_integer+0xa5>
 80496cf:	80 bd 78 ff ff ff 00 	cmpb   $0x0,-0x88(%ebp)
 80496d6:	74 07                	je     80496df <format_integer+0xa5>
 80496d8:	c7 45 e0 2d 00 00 00 	movl   $0x2d,-0x20(%ebp)
 80496df:	8b 45 1c             	mov    0x1c(%ebp),%eax
 80496e2:	8b 00                	mov    (%eax),%eax
 80496e4:	83 e0 08             	and    $0x8,%eax
 80496e7:	85 c0                	test   %eax,%eax
 80496e9:	74 20                	je     804970b <format_integer+0xd1>
 80496eb:	8b 45 80             	mov    -0x80(%ebp),%eax
 80496ee:	83 f0 00             	xor    $0x0,%eax
 80496f1:	89 c1                	mov    %eax,%ecx
 80496f3:	8b 45 84             	mov    -0x7c(%ebp),%eax
 80496f6:	83 f0 00             	xor    $0x0,%eax
 80496f9:	89 c3                	mov    %eax,%ebx
 80496fb:	89 d8                	mov    %ebx,%eax
 80496fd:	09 c8                	or     %ecx,%eax
 80496ff:	85 c0                	test   %eax,%eax
 8049701:	74 08                	je     804970b <format_integer+0xd1>
 8049703:	8b 45 18             	mov    0x18(%ebp),%eax
 8049706:	8b 40 08             	mov    0x8(%eax),%eax
 8049709:	eb 05                	jmp    8049710 <format_integer+0xd6>
 804970b:	b8 00 00 00 00       	mov    $0x0,%eax
 8049710:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 8049713:	8d 45 90             	lea    -0x70(%ebp),%eax
 8049716:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8049719:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 8049720:	e9 a2 00 00 00       	jmp    80497c7 <format_integer+0x18d>
 8049725:	8b 45 1c             	mov    0x1c(%ebp),%eax
 8049728:	8b 00                	mov    (%eax),%eax
 804972a:	83 e0 20             	and    $0x20,%eax
 804972d:	85 c0                	test   %eax,%eax
 804972f:	74 24                	je     8049755 <format_integer+0x11b>
 8049731:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
 8049735:	7e 1e                	jle    8049755 <format_integer+0x11b>
 8049737:	8b 45 18             	mov    0x18(%ebp),%eax
 804973a:	8b 48 0c             	mov    0xc(%eax),%ecx
 804973d:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8049740:	99                   	cltd   
 8049741:	f7 f9                	idiv   %ecx
 8049743:	89 d0                	mov    %edx,%eax
 8049745:	85 c0                	test   %eax,%eax
 8049747:	75 0c                	jne    8049755 <format_integer+0x11b>
 8049749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804974c:	8d 50 01             	lea    0x1(%eax),%edx
 804974f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8049752:	c6 00 2c             	movb   $0x2c,(%eax)
 8049755:	8b 45 18             	mov    0x18(%ebp),%eax
 8049758:	8b 40 04             	mov    0x4(%eax),%eax
 804975b:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 8049761:	8b 45 18             	mov    0x18(%ebp),%eax
 8049764:	8b 00                	mov    (%eax),%eax
 8049766:	89 c1                	mov    %eax,%ecx
 8049768:	89 c3                	mov    %eax,%ebx
 804976a:	c1 fb 1f             	sar    $0x1f,%ebx
 804976d:	8b 45 80             	mov    -0x80(%ebp),%eax
 8049770:	8b 55 84             	mov    -0x7c(%ebp),%edx
 8049773:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 8049777:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 804977b:	89 04 24             	mov    %eax,(%esp)
 804977e:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049782:	e8 8b 13 00 00       	call   804ab12 <__umoddi3>
 8049787:	8b 9d 74 ff ff ff    	mov    -0x8c(%ebp),%ebx
 804978d:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
 8049790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049793:	8d 50 01             	lea    0x1(%eax),%edx
 8049796:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8049799:	0f b6 11             	movzbl (%ecx),%edx
 804979c:	88 10                	mov    %dl,(%eax)
 804979e:	8b 45 18             	mov    0x18(%ebp),%eax
 80497a1:	8b 00                	mov    (%eax),%eax
 80497a3:	99                   	cltd   
 80497a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 80497a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
 80497ac:	8b 45 80             	mov    -0x80(%ebp),%eax
 80497af:	8b 55 84             	mov    -0x7c(%ebp),%edx
 80497b2:	89 04 24             	mov    %eax,(%esp)
 80497b5:	89 54 24 04          	mov    %edx,0x4(%esp)
 80497b9:	e8 12 13 00 00       	call   804aad0 <__udivdi3>
 80497be:	89 45 80             	mov    %eax,-0x80(%ebp)
 80497c1:	89 55 84             	mov    %edx,-0x7c(%ebp)
 80497c4:	ff 45 d8             	incl   -0x28(%ebp)
 80497c7:	8b 45 80             	mov    -0x80(%ebp),%eax
 80497ca:	83 f0 00             	xor    $0x0,%eax
 80497cd:	89 c6                	mov    %eax,%esi
 80497cf:	8b 45 84             	mov    -0x7c(%ebp),%eax
 80497d2:	83 f0 00             	xor    $0x0,%eax
 80497d5:	89 c7                	mov    %eax,%edi
 80497d7:	89 f8                	mov    %edi,%eax
 80497d9:	09 f0                	or     %esi,%eax
 80497db:	85 c0                	test   %eax,%eax
 80497dd:	0f 85 42 ff ff ff    	jne    8049725 <format_integer+0xeb>
 80497e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
 80497e6:	8b 40 08             	mov    0x8(%eax),%eax
 80497e9:	85 c0                	test   %eax,%eax
 80497eb:	78 08                	js     80497f5 <format_integer+0x1bb>
 80497ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
 80497f0:	8b 40 08             	mov    0x8(%eax),%eax
 80497f3:	eb 05                	jmp    80497fa <format_integer+0x1c0>
 80497f5:	b8 01 00 00 00       	mov    $0x1,%eax
 80497fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
 80497fd:	eb 0c                	jmp    804980b <format_integer+0x1d1>
 80497ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049802:	8d 50 01             	lea    0x1(%eax),%edx
 8049805:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8049808:	c6 00 30             	movb   $0x30,(%eax)
 804980b:	8d 55 90             	lea    -0x70(%ebp),%edx
 804980e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049811:	29 d0                	sub    %edx,%eax
 8049813:	39 45 d0             	cmp    %eax,-0x30(%ebp)
 8049816:	7e 0b                	jle    8049823 <format_integer+0x1e9>
 8049818:	8d 45 90             	lea    -0x70(%ebp),%eax
 804981b:	83 c0 3f             	add    $0x3f,%eax
 804981e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 8049821:	72 dc                	jb     80497ff <format_integer+0x1c5>
 8049823:	8b 45 1c             	mov    0x1c(%ebp),%eax
 8049826:	8b 00                	mov    (%eax),%eax
 8049828:	83 e0 08             	and    $0x8,%eax
 804982b:	85 c0                	test   %eax,%eax
 804982d:	74 29                	je     8049858 <format_integer+0x21e>
 804982f:	8b 45 18             	mov    0x18(%ebp),%eax
 8049832:	8b 00                	mov    (%eax),%eax
 8049834:	83 f8 08             	cmp    $0x8,%eax
 8049837:	75 1f                	jne    8049858 <format_integer+0x21e>
 8049839:	8d 45 90             	lea    -0x70(%ebp),%eax
 804983c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 804983f:	74 0b                	je     804984c <format_integer+0x212>
 8049841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049844:	48                   	dec    %eax
 8049845:	0f b6 00             	movzbl (%eax),%eax
 8049848:	3c 30                	cmp    $0x30,%al
 804984a:	74 0c                	je     8049858 <format_integer+0x21e>
 804984c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804984f:	8d 50 01             	lea    0x1(%eax),%edx
 8049852:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8049855:	c6 00 30             	movb   $0x30,(%eax)
 8049858:	8b 45 1c             	mov    0x1c(%ebp),%eax
 804985b:	8b 40 04             	mov    0x4(%eax),%eax
 804985e:	8d 4d 90             	lea    -0x70(%ebp),%ecx
 8049861:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 8049864:	29 ca                	sub    %ecx,%edx
 8049866:	29 d0                	sub    %edx,%eax
 8049868:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804986c:	74 07                	je     8049875 <format_integer+0x23b>
 804986e:	ba 02 00 00 00       	mov    $0x2,%edx
 8049873:	eb 05                	jmp    804987a <format_integer+0x240>
 8049875:	ba 00 00 00 00       	mov    $0x0,%edx
 804987a:	29 d0                	sub    %edx,%eax
 804987c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8049880:	0f 95 c2             	setne  %dl
 8049883:	0f b6 d2             	movzbl %dl,%edx
 8049886:	29 d0                	sub    %edx,%eax
 8049888:	89 45 dc             	mov    %eax,-0x24(%ebp)
 804988b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 804988f:	79 07                	jns    8049898 <format_integer+0x25e>
 8049891:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 8049898:	8b 45 1c             	mov    0x1c(%ebp),%eax
 804989b:	8b 00                	mov    (%eax),%eax
 804989d:	83 e0 11             	and    $0x11,%eax
 80498a0:	85 c0                	test   %eax,%eax
 80498a2:	75 21                	jne    80498c5 <format_integer+0x28b>
 80498a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80498a7:	8b 55 24             	mov    0x24(%ebp),%edx
 80498aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
 80498ae:	8b 55 20             	mov    0x20(%ebp),%edx
 80498b1:	89 54 24 08          	mov    %edx,0x8(%esp)
 80498b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 80498b9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 80498c0:	e8 d4 00 00 00       	call   8049999 <output_dup>
 80498c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80498c9:	74 15                	je     80498e0 <format_integer+0x2a6>
 80498cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80498ce:	0f be c0             	movsbl %al,%eax
 80498d1:	8b 55 24             	mov    0x24(%ebp),%edx
 80498d4:	89 54 24 04          	mov    %edx,0x4(%esp)
 80498d8:	89 04 24             	mov    %eax,(%esp)
 80498db:	8b 45 20             	mov    0x20(%ebp),%eax
 80498de:	ff d0                	call   *%eax
 80498e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80498e4:	74 28                	je     804990e <format_integer+0x2d4>
 80498e6:	8b 45 24             	mov    0x24(%ebp),%eax
 80498e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 80498ed:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
 80498f4:	8b 45 20             	mov    0x20(%ebp),%eax
 80498f7:	ff d0                	call   *%eax
 80498f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 80498fc:	0f be c0             	movsbl %al,%eax
 80498ff:	8b 55 24             	mov    0x24(%ebp),%edx
 8049902:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049906:	89 04 24             	mov    %eax,(%esp)
 8049909:	8b 45 20             	mov    0x20(%ebp),%eax
 804990c:	ff d0                	call   *%eax
 804990e:	8b 45 1c             	mov    0x1c(%ebp),%eax
 8049911:	8b 00                	mov    (%eax),%eax
 8049913:	83 e0 10             	and    $0x10,%eax
 8049916:	85 c0                	test   %eax,%eax
 8049918:	74 3e                	je     8049958 <format_integer+0x31e>
 804991a:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804991d:	8b 55 24             	mov    0x24(%ebp),%edx
 8049920:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049924:	8b 55 20             	mov    0x20(%ebp),%edx
 8049927:	89 54 24 08          	mov    %edx,0x8(%esp)
 804992b:	89 44 24 04          	mov    %eax,0x4(%esp)
 804992f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
 8049936:	e8 5e 00 00 00       	call   8049999 <output_dup>
 804993b:	eb 1b                	jmp    8049958 <format_integer+0x31e>
 804993d:	ff 4d e4             	decl   -0x1c(%ebp)
 8049940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049943:	0f b6 00             	movzbl (%eax),%eax
 8049946:	0f be c0             	movsbl %al,%eax
 8049949:	8b 55 24             	mov    0x24(%ebp),%edx
 804994c:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049950:	89 04 24             	mov    %eax,(%esp)
 8049953:	8b 45 20             	mov    0x20(%ebp),%eax
 8049956:	ff d0                	call   *%eax
 8049958:	8d 45 90             	lea    -0x70(%ebp),%eax
 804995b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 804995e:	77 dd                	ja     804993d <format_integer+0x303>
 8049960:	8b 45 1c             	mov    0x1c(%ebp),%eax
 8049963:	8b 00                	mov    (%eax),%eax
 8049965:	83 e0 01             	and    $0x1,%eax
 8049968:	85 c0                	test   %eax,%eax
 804996a:	74 21                	je     804998d <format_integer+0x353>
 804996c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804996f:	8b 55 24             	mov    0x24(%ebp),%edx
 8049972:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049976:	8b 55 20             	mov    0x20(%ebp),%edx
 8049979:	89 54 24 08          	mov    %edx,0x8(%esp)
 804997d:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049981:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 8049988:	e8 0c 00 00 00       	call   8049999 <output_dup>
 804998d:	90                   	nop
 804998e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
 8049994:	5b                   	pop    %ebx
 8049995:	5e                   	pop    %esi
 8049996:	5f                   	pop    %edi
 8049997:	5d                   	pop    %ebp
 8049998:	c3                   	ret    

08049999 <output_dup>:
 8049999:	55                   	push   %ebp
 804999a:	89 e5                	mov    %esp,%ebp
 804999c:	83 ec 28             	sub    $0x28,%esp
 804999f:	8b 45 08             	mov    0x8(%ebp),%eax
 80499a2:	88 45 f4             	mov    %al,-0xc(%ebp)
 80499a5:	eb 13                	jmp    80499ba <output_dup+0x21>
 80499a7:	0f be 45 f4          	movsbl -0xc(%ebp),%eax
 80499ab:	8b 55 14             	mov    0x14(%ebp),%edx
 80499ae:	89 54 24 04          	mov    %edx,0x4(%esp)
 80499b2:	89 04 24             	mov    %eax,(%esp)
 80499b5:	8b 45 10             	mov    0x10(%ebp),%eax
 80499b8:	ff d0                	call   *%eax
 80499ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 80499bd:	8d 50 ff             	lea    -0x1(%eax),%edx
 80499c0:	89 55 0c             	mov    %edx,0xc(%ebp)
 80499c3:	85 c0                	test   %eax,%eax
 80499c5:	75 e0                	jne    80499a7 <output_dup+0xe>
 80499c7:	90                   	nop
 80499c8:	90                   	nop
 80499c9:	89 ec                	mov    %ebp,%esp
 80499cb:	5d                   	pop    %ebp
 80499cc:	c3                   	ret    

080499cd <format_string>:
 80499cd:	55                   	push   %ebp
 80499ce:	89 e5                	mov    %esp,%ebp
 80499d0:	83 ec 28             	sub    $0x28,%esp
 80499d3:	8b 45 10             	mov    0x10(%ebp),%eax
 80499d6:	8b 40 04             	mov    0x4(%eax),%eax
 80499d9:	39 45 0c             	cmp    %eax,0xc(%ebp)
 80499dc:	7d 35                	jge    8049a13 <format_string+0x46>
 80499de:	8b 45 10             	mov    0x10(%ebp),%eax
 80499e1:	8b 00                	mov    (%eax),%eax
 80499e3:	83 e0 01             	and    $0x1,%eax
 80499e6:	85 c0                	test   %eax,%eax
 80499e8:	75 29                	jne    8049a13 <format_string+0x46>
 80499ea:	8b 45 10             	mov    0x10(%ebp),%eax
 80499ed:	8b 40 04             	mov    0x4(%eax),%eax
 80499f0:	2b 45 0c             	sub    0xc(%ebp),%eax
 80499f3:	89 c2                	mov    %eax,%edx
 80499f5:	8b 45 18             	mov    0x18(%ebp),%eax
 80499f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 80499fc:	8b 45 14             	mov    0x14(%ebp),%eax
 80499ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049a03:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049a07:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 8049a0e:	e8 86 ff ff ff       	call   8049999 <output_dup>
 8049a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8049a1a:	eb 20                	jmp    8049a3c <format_string+0x6f>
 8049a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8049a1f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049a22:	01 d0                	add    %edx,%eax
 8049a24:	0f b6 00             	movzbl (%eax),%eax
 8049a27:	0f be c0             	movsbl %al,%eax
 8049a2a:	8b 55 18             	mov    0x18(%ebp),%edx
 8049a2d:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049a31:	89 04 24             	mov    %eax,(%esp)
 8049a34:	8b 45 14             	mov    0x14(%ebp),%eax
 8049a37:	ff d0                	call   *%eax
 8049a39:	ff 45 f4             	incl   -0xc(%ebp)
 8049a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049a3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 8049a42:	7c d8                	jl     8049a1c <format_string+0x4f>
 8049a44:	8b 45 10             	mov    0x10(%ebp),%eax
 8049a47:	8b 40 04             	mov    0x4(%eax),%eax
 8049a4a:	39 45 0c             	cmp    %eax,0xc(%ebp)
 8049a4d:	7d 35                	jge    8049a84 <format_string+0xb7>
 8049a4f:	8b 45 10             	mov    0x10(%ebp),%eax
 8049a52:	8b 00                	mov    (%eax),%eax
 8049a54:	83 e0 01             	and    $0x1,%eax
 8049a57:	85 c0                	test   %eax,%eax
 8049a59:	74 29                	je     8049a84 <format_string+0xb7>
 8049a5b:	8b 45 10             	mov    0x10(%ebp),%eax
 8049a5e:	8b 40 04             	mov    0x4(%eax),%eax
 8049a61:	2b 45 0c             	sub    0xc(%ebp),%eax
 8049a64:	89 c2                	mov    %eax,%edx
 8049a66:	8b 45 18             	mov    0x18(%ebp),%eax
 8049a69:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049a6d:	8b 45 14             	mov    0x14(%ebp),%eax
 8049a70:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049a74:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049a78:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 8049a7f:	e8 15 ff ff ff       	call   8049999 <output_dup>
 8049a84:	90                   	nop
 8049a85:	89 ec                	mov    %ebp,%esp
 8049a87:	5d                   	pop    %ebp
 8049a88:	c3                   	ret    

08049a89 <__printf>:
 8049a89:	55                   	push   %ebp
 8049a8a:	89 e5                	mov    %esp,%ebp
 8049a8c:	83 ec 28             	sub    $0x28,%esp
 8049a8f:	8d 45 14             	lea    0x14(%ebp),%eax
 8049a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049a98:	8b 55 10             	mov    0x10(%ebp),%edx
 8049a9b:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
 8049aa2:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049aaa:	8b 45 08             	mov    0x8(%ebp),%eax
 8049aad:	89 04 24             	mov    %eax,(%esp)
 8049ab0:	e8 71 f1 ff ff       	call   8048c26 <__vprintf>
 8049ab5:	90                   	nop
 8049ab6:	89 ec                	mov    %ebp,%esp
 8049ab8:	5d                   	pop    %ebp
 8049ab9:	c3                   	ret    

08049aba <hex_dump>:
 8049aba:	55                   	push   %ebp
 8049abb:	89 e5                	mov    %esp,%ebp
 8049abd:	83 ec 48             	sub    $0x48,%esp
 8049ac0:	8b 45 14             	mov    0x14(%ebp),%eax
 8049ac3:	88 45 d4             	mov    %al,-0x2c(%ebp)
 8049ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049acc:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%ebp)
 8049ad3:	e9 a6 01 00 00       	jmp    8049c7e <hex_dump+0x1c4>
 8049ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 8049adb:	ba 00 00 00 00       	mov    $0x0,%edx
 8049ae0:	f7 75 e8             	divl   -0x18(%ebp)
 8049ae3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8049ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049aef:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 8049af2:	39 45 10             	cmp    %eax,0x10(%ebp)
 8049af5:	73 0b                	jae    8049b02 <hex_dump+0x48>
 8049af7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 8049afa:	8b 45 10             	mov    0x10(%ebp),%eax
 8049afd:	01 d0                	add    %edx,%eax
 8049aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049b05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 8049b08:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8049b0b:	8b 45 08             	mov    0x8(%ebp),%eax
 8049b0e:	ba 00 00 00 00       	mov    $0x0,%edx
 8049b13:	f7 75 e8             	divl   -0x18(%ebp)
 8049b16:	0f af 45 e8          	imul   -0x18(%ebp),%eax
 8049b1a:	ba 00 00 00 00       	mov    $0x0,%edx
 8049b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049b23:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049b27:	c7 04 24 08 b7 04 08 	movl   $0x804b708,(%esp)
 8049b2e:	e8 cb f0 ff ff       	call   8048bfe <printf>
 8049b33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8049b3a:	eb 0f                	jmp    8049b4b <hex_dump+0x91>
 8049b3c:	c7 04 24 10 b7 04 08 	movl   $0x804b710,(%esp)
 8049b43:	e8 b6 f0 ff ff       	call   8048bfe <printf>
 8049b48:	ff 45 ec             	incl   -0x14(%ebp)
 8049b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049b4e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 8049b51:	72 e9                	jb     8049b3c <hex_dump+0x82>
 8049b53:	eb 41                	jmp    8049b96 <hex_dump+0xdc>
 8049b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049b58:	d1 e8                	shr    %eax
 8049b5a:	48                   	dec    %eax
 8049b5b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8049b5e:	75 07                	jne    8049b67 <hex_dump+0xad>
 8049b60:	ba 2d 00 00 00       	mov    $0x2d,%edx
 8049b65:	eb 05                	jmp    8049b6c <hex_dump+0xb2>
 8049b67:	ba 20 00 00 00       	mov    $0x20,%edx
 8049b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049b6f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 8049b72:	89 c1                	mov    %eax,%ecx
 8049b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049b77:	01 c8                	add    %ecx,%eax
 8049b79:	0f b6 00             	movzbl (%eax),%eax
 8049b7c:	0f b6 c0             	movzbl %al,%eax
 8049b7f:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049b83:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049b87:	c7 04 24 14 b7 04 08 	movl   $0x804b714,(%esp)
 8049b8e:	e8 6b f0 ff ff       	call   8048bfe <printf>
 8049b93:	ff 45 ec             	incl   -0x14(%ebp)
 8049b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049b99:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 8049b9c:	72 b7                	jb     8049b55 <hex_dump+0x9b>
 8049b9e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%ebp)
 8049ba2:	0f 84 b8 00 00 00    	je     8049c60 <hex_dump+0x1a6>
 8049ba8:	eb 0f                	jmp    8049bb9 <hex_dump+0xff>
 8049baa:	c7 04 24 10 b7 04 08 	movl   $0x804b710,(%esp)
 8049bb1:	e8 48 f0 ff ff       	call   8048bfe <printf>
 8049bb6:	ff 45 ec             	incl   -0x14(%ebp)
 8049bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049bbc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
 8049bbf:	72 e9                	jb     8049baa <hex_dump+0xf0>
 8049bc1:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
 8049bc8:	e8 38 15 00 00       	call   804b105 <putchar>
 8049bcd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8049bd4:	eb 0f                	jmp    8049be5 <hex_dump+0x12b>
 8049bd6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 8049bdd:	e8 23 15 00 00       	call   804b105 <putchar>
 8049be2:	ff 45 ec             	incl   -0x14(%ebp)
 8049be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049be8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 8049beb:	72 e9                	jb     8049bd6 <hex_dump+0x11c>
 8049bed:	eb 44                	jmp    8049c33 <hex_dump+0x179>
 8049bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049bf2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 8049bf5:	89 c2                	mov    %eax,%edx
 8049bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049bfa:	01 d0                	add    %edx,%eax
 8049bfc:	0f b6 00             	movzbl (%eax),%eax
 8049bff:	0f b6 c0             	movzbl %al,%eax
 8049c02:	89 04 24             	mov    %eax,(%esp)
 8049c05:	e8 03 ef ff ff       	call   8048b0d <isprint>
 8049c0a:	85 c0                	test   %eax,%eax
 8049c0c:	74 15                	je     8049c23 <hex_dump+0x169>
 8049c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049c11:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 8049c14:	89 c2                	mov    %eax,%edx
 8049c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049c19:	01 d0                	add    %edx,%eax
 8049c1b:	0f b6 00             	movzbl (%eax),%eax
 8049c1e:	0f b6 c0             	movzbl %al,%eax
 8049c21:	eb 05                	jmp    8049c28 <hex_dump+0x16e>
 8049c23:	b8 2e 00 00 00       	mov    $0x2e,%eax
 8049c28:	89 04 24             	mov    %eax,(%esp)
 8049c2b:	e8 d5 14 00 00       	call   804b105 <putchar>
 8049c30:	ff 45 ec             	incl   -0x14(%ebp)
 8049c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049c36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 8049c39:	72 b4                	jb     8049bef <hex_dump+0x135>
 8049c3b:	eb 0f                	jmp    8049c4c <hex_dump+0x192>
 8049c3d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 8049c44:	e8 bc 14 00 00       	call   804b105 <putchar>
 8049c49:	ff 45 ec             	incl   -0x14(%ebp)
 8049c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049c4f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
 8049c52:	72 e9                	jb     8049c3d <hex_dump+0x183>
 8049c54:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
 8049c5b:	e8 a5 14 00 00       	call   804b105 <putchar>
 8049c60:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 8049c67:	e8 99 14 00 00       	call   804b105 <putchar>
 8049c6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8049c6f:	01 45 08             	add    %eax,0x8(%ebp)
 8049c72:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8049c75:	01 45 f4             	add    %eax,-0xc(%ebp)
 8049c78:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8049c7b:	29 45 10             	sub    %eax,0x10(%ebp)
 8049c7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049c82:	0f 85 50 fe ff ff    	jne    8049ad8 <hex_dump+0x1e>
 8049c88:	90                   	nop
 8049c89:	90                   	nop
 8049c8a:	89 ec                	mov    %ebp,%esp
 8049c8c:	5d                   	pop    %ebp
 8049c8d:	c3                   	ret    

08049c8e <print_human_readable_size>:
 8049c8e:	55                   	push   %ebp
 8049c8f:	89 e5                	mov    %esp,%ebp
 8049c91:	83 ec 38             	sub    $0x38,%esp
 8049c94:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8049c97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 8049c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8049c9d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 8049ca0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 8049ca3:	83 f1 01             	xor    $0x1,%ecx
 8049ca6:	89 c8                	mov    %ecx,%eax
 8049ca8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 8049cab:	83 f1 00             	xor    $0x0,%ecx
 8049cae:	89 ca                	mov    %ecx,%edx
 8049cb0:	09 d0                	or     %edx,%eax
 8049cb2:	85 c0                	test   %eax,%eax
 8049cb4:	75 0e                	jne    8049cc4 <print_human_readable_size+0x36>
 8049cb6:	c7 04 24 1d b7 04 08 	movl   $0x804b71d,(%esp)
 8049cbd:	e8 3c ef ff ff       	call   8048bfe <printf>
 8049cc2:	eb 61                	jmp    8049d25 <print_human_readable_size+0x97>
 8049cc4:	c7 45 f4 f0 c9 04 08 	movl   $0x804c9f0,-0xc(%ebp)
 8049ccb:	eb 17                	jmp    8049ce4 <print_human_readable_size+0x56>
 8049ccd:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8049cd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 8049cd3:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
 8049cd7:	c1 ea 0a             	shr    $0xa,%edx
 8049cda:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8049cdd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8049ce0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 8049ce4:	ba ff 03 00 00       	mov    $0x3ff,%edx
 8049ce9:	b8 00 00 00 00       	mov    $0x0,%eax
 8049cee:	3b 55 e0             	cmp    -0x20(%ebp),%edx
 8049cf1:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
 8049cf4:	73 0c                	jae    8049d02 <print_human_readable_size+0x74>
 8049cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049cf9:	83 c0 04             	add    $0x4,%eax
 8049cfc:	8b 00                	mov    (%eax),%eax
 8049cfe:	85 c0                	test   %eax,%eax
 8049d00:	75 cb                	jne    8049ccd <print_human_readable_size+0x3f>
 8049d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049d05:	8b 00                	mov    (%eax),%eax
 8049d07:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8049d0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 8049d11:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049d15:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049d19:	c7 04 24 24 b7 04 08 	movl   $0x804b724,(%esp)
 8049d20:	e8 d9 ee ff ff       	call   8048bfe <printf>
 8049d25:	90                   	nop
 8049d26:	89 ec                	mov    %ebp,%esp
 8049d28:	5d                   	pop    %ebp
 8049d29:	c3                   	ret    

08049d2a <memcpy>:
 8049d2a:	55                   	push   %ebp
 8049d2b:	89 e5                	mov    %esp,%ebp
 8049d2d:	83 ec 38             	sub    $0x38,%esp
 8049d30:	8b 45 08             	mov    0x8(%ebp),%eax
 8049d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049d36:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8049d40:	75 32                	jne    8049d74 <memcpy+0x4a>
 8049d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049d46:	74 2c                	je     8049d74 <memcpy+0x4a>
 8049d48:	c7 44 24 10 48 b7 04 	movl   $0x804b748,0x10(%esp)
 8049d4f:	08 
 8049d50:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049d57:	08 
 8049d58:	c7 44 24 08 58 b8 04 	movl   $0x804b858,0x8(%esp)
 8049d5f:	08 
 8049d60:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
 8049d67:	00 
 8049d68:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049d6f:	e8 e5 0d 00 00       	call   804ab59 <debug_panic>
 8049d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8049d78:	75 49                	jne    8049dc3 <memcpy+0x99>
 8049d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049d7e:	74 43                	je     8049dc3 <memcpy+0x99>
 8049d80:	c7 44 24 10 8b b7 04 	movl   $0x804b78b,0x10(%esp)
 8049d87:	08 
 8049d88:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049d8f:	08 
 8049d90:	c7 44 24 08 58 b8 04 	movl   $0x804b858,0x8(%esp)
 8049d97:	08 
 8049d98:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
 8049d9f:	00 
 8049da0:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049da7:	e8 ad 0d 00 00       	call   804ab59 <debug_panic>
 8049dac:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8049daf:	8d 42 01             	lea    0x1(%edx),%eax
 8049db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049db8:	8d 48 01             	lea    0x1(%eax),%ecx
 8049dbb:	89 4d f4             	mov    %ecx,-0xc(%ebp)
 8049dbe:	0f b6 12             	movzbl (%edx),%edx
 8049dc1:	88 10                	mov    %dl,(%eax)
 8049dc3:	8b 45 10             	mov    0x10(%ebp),%eax
 8049dc6:	8d 50 ff             	lea    -0x1(%eax),%edx
 8049dc9:	89 55 10             	mov    %edx,0x10(%ebp)
 8049dcc:	85 c0                	test   %eax,%eax
 8049dce:	75 dc                	jne    8049dac <memcpy+0x82>
 8049dd0:	8b 45 08             	mov    0x8(%ebp),%eax
 8049dd3:	89 ec                	mov    %ebp,%esp
 8049dd5:	5d                   	pop    %ebp
 8049dd6:	c3                   	ret    

08049dd7 <memmove>:
 8049dd7:	55                   	push   %ebp
 8049dd8:	89 e5                	mov    %esp,%ebp
 8049dda:	83 ec 38             	sub    $0x38,%esp
 8049ddd:	8b 45 08             	mov    0x8(%ebp),%eax
 8049de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049de3:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8049ded:	75 32                	jne    8049e21 <memmove+0x4a>
 8049def:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049df3:	74 2c                	je     8049e21 <memmove+0x4a>
 8049df5:	c7 44 24 10 48 b7 04 	movl   $0x804b748,0x10(%esp)
 8049dfc:	08 
 8049dfd:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049e04:	08 
 8049e05:	c7 44 24 08 60 b8 04 	movl   $0x804b860,0x8(%esp)
 8049e0c:	08 
 8049e0d:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
 8049e14:	00 
 8049e15:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049e1c:	e8 38 0d 00 00       	call   804ab59 <debug_panic>
 8049e21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8049e25:	75 32                	jne    8049e59 <memmove+0x82>
 8049e27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049e2b:	74 2c                	je     8049e59 <memmove+0x82>
 8049e2d:	c7 44 24 10 8b b7 04 	movl   $0x804b78b,0x10(%esp)
 8049e34:	08 
 8049e35:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049e3c:	08 
 8049e3d:	c7 44 24 08 60 b8 04 	movl   $0x804b860,0x8(%esp)
 8049e44:	08 
 8049e45:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
 8049e4c:	00 
 8049e4d:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049e54:	e8 00 0d 00 00       	call   804ab59 <debug_panic>
 8049e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049e5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 8049e5f:	73 28                	jae    8049e89 <memmove+0xb2>
 8049e61:	eb 17                	jmp    8049e7a <memmove+0xa3>
 8049e63:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8049e66:	8d 42 01             	lea    0x1(%edx),%eax
 8049e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049e6f:	8d 48 01             	lea    0x1(%eax),%ecx
 8049e72:	89 4d f4             	mov    %ecx,-0xc(%ebp)
 8049e75:	0f b6 12             	movzbl (%edx),%edx
 8049e78:	88 10                	mov    %dl,(%eax)
 8049e7a:	8b 45 10             	mov    0x10(%ebp),%eax
 8049e7d:	8d 50 ff             	lea    -0x1(%eax),%edx
 8049e80:	89 55 10             	mov    %edx,0x10(%ebp)
 8049e83:	85 c0                	test   %eax,%eax
 8049e85:	75 dc                	jne    8049e63 <memmove+0x8c>
 8049e87:	eb 2c                	jmp    8049eb5 <memmove+0xde>
 8049e89:	8b 45 10             	mov    0x10(%ebp),%eax
 8049e8c:	01 45 f4             	add    %eax,-0xc(%ebp)
 8049e8f:	8b 45 10             	mov    0x10(%ebp),%eax
 8049e92:	01 45 f0             	add    %eax,-0x10(%ebp)
 8049e95:	eb 11                	jmp    8049ea8 <memmove+0xd1>
 8049e97:	ff 4d f0             	decl   -0x10(%ebp)
 8049e9a:	ff 4d f4             	decl   -0xc(%ebp)
 8049e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049ea0:	0f b6 10             	movzbl (%eax),%edx
 8049ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049ea6:	88 10                	mov    %dl,(%eax)
 8049ea8:	8b 45 10             	mov    0x10(%ebp),%eax
 8049eab:	8d 50 ff             	lea    -0x1(%eax),%edx
 8049eae:	89 55 10             	mov    %edx,0x10(%ebp)
 8049eb1:	85 c0                	test   %eax,%eax
 8049eb3:	75 e2                	jne    8049e97 <memmove+0xc0>
 8049eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049eb8:	89 ec                	mov    %ebp,%esp
 8049eba:	5d                   	pop    %ebp
 8049ebb:	c3                   	ret    

08049ebc <memcmp>:
 8049ebc:	55                   	push   %ebp
 8049ebd:	89 e5                	mov    %esp,%ebp
 8049ebf:	83 ec 38             	sub    $0x38,%esp
 8049ec2:	8b 45 08             	mov    0x8(%ebp),%eax
 8049ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8049ed2:	75 32                	jne    8049f06 <memcmp+0x4a>
 8049ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049ed8:	74 2c                	je     8049f06 <memcmp+0x4a>
 8049eda:	c7 44 24 10 a4 b7 04 	movl   $0x804b7a4,0x10(%esp)
 8049ee1:	08 
 8049ee2:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049ee9:	08 
 8049eea:	c7 44 24 08 68 b8 04 	movl   $0x804b868,0x8(%esp)
 8049ef1:	08 
 8049ef2:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
 8049ef9:	00 
 8049efa:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049f01:	e8 53 0c 00 00       	call   804ab59 <debug_panic>
 8049f06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8049f0a:	75 66                	jne    8049f72 <memcmp+0xb6>
 8049f0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049f10:	74 60                	je     8049f72 <memcmp+0xb6>
 8049f12:	c7 44 24 10 bb b7 04 	movl   $0x804b7bb,0x10(%esp)
 8049f19:	08 
 8049f1a:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049f21:	08 
 8049f22:	c7 44 24 08 68 b8 04 	movl   $0x804b868,0x8(%esp)
 8049f29:	08 
 8049f2a:	c7 44 24 04 36 00 00 	movl   $0x36,0x4(%esp)
 8049f31:	00 
 8049f32:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049f39:	e8 1b 0c 00 00       	call   804ab59 <debug_panic>
 8049f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049f41:	0f b6 10             	movzbl (%eax),%edx
 8049f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049f47:	0f b6 00             	movzbl (%eax),%eax
 8049f4a:	38 c2                	cmp    %al,%dl
 8049f4c:	74 1e                	je     8049f6c <memcmp+0xb0>
 8049f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049f51:	0f b6 10             	movzbl (%eax),%edx
 8049f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049f57:	0f b6 00             	movzbl (%eax),%eax
 8049f5a:	38 c2                	cmp    %al,%dl
 8049f5c:	76 07                	jbe    8049f65 <memcmp+0xa9>
 8049f5e:	b8 01 00 00 00       	mov    $0x1,%eax
 8049f63:	eb 1f                	jmp    8049f84 <memcmp+0xc8>
 8049f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049f6a:	eb 18                	jmp    8049f84 <memcmp+0xc8>
 8049f6c:	ff 45 f4             	incl   -0xc(%ebp)
 8049f6f:	ff 45 f0             	incl   -0x10(%ebp)
 8049f72:	8b 45 10             	mov    0x10(%ebp),%eax
 8049f75:	8d 50 ff             	lea    -0x1(%eax),%edx
 8049f78:	89 55 10             	mov    %edx,0x10(%ebp)
 8049f7b:	85 c0                	test   %eax,%eax
 8049f7d:	75 bf                	jne    8049f3e <memcmp+0x82>
 8049f7f:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f84:	89 ec                	mov    %ebp,%esp
 8049f86:	5d                   	pop    %ebp
 8049f87:	c3                   	ret    

08049f88 <strcmp>:
 8049f88:	55                   	push   %ebp
 8049f89:	89 e5                	mov    %esp,%ebp
 8049f8b:	83 ec 38             	sub    $0x38,%esp
 8049f8e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049f94:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8049f9e:	75 2c                	jne    8049fcc <strcmp+0x44>
 8049fa0:	c7 44 24 10 d2 b7 04 	movl   $0x804b7d2,0x10(%esp)
 8049fa7:	08 
 8049fa8:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049faf:	08 
 8049fb0:	c7 44 24 08 70 b8 04 	movl   $0x804b870,0x8(%esp)
 8049fb7:	08 
 8049fb8:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
 8049fbf:	00 
 8049fc0:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049fc7:	e8 8d 0b 00 00       	call   804ab59 <debug_panic>
 8049fcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8049fd0:	75 32                	jne    804a004 <strcmp+0x7c>
 8049fd2:	c7 44 24 10 dc b7 04 	movl   $0x804b7dc,0x10(%esp)
 8049fd9:	08 
 8049fda:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 8049fe1:	08 
 8049fe2:	c7 44 24 08 70 b8 04 	movl   $0x804b870,0x8(%esp)
 8049fe9:	08 
 8049fea:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
 8049ff1:	00 
 8049ff2:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 8049ff9:	e8 5b 0b 00 00       	call   804ab59 <debug_panic>
 8049ffe:	ff 45 f4             	incl   -0xc(%ebp)
 804a001:	ff 45 f0             	incl   -0x10(%ebp)
 804a004:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a007:	0f b6 00             	movzbl (%eax),%eax
 804a00a:	84 c0                	test   %al,%al
 804a00c:	74 10                	je     804a01e <strcmp+0x96>
 804a00e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a011:	0f b6 10             	movzbl (%eax),%edx
 804a014:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a017:	0f b6 00             	movzbl (%eax),%eax
 804a01a:	38 c2                	cmp    %al,%dl
 804a01c:	74 e0                	je     8049ffe <strcmp+0x76>
 804a01e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a021:	0f b6 10             	movzbl (%eax),%edx
 804a024:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a027:	0f b6 00             	movzbl (%eax),%eax
 804a02a:	38 c2                	cmp    %al,%dl
 804a02c:	72 16                	jb     804a044 <strcmp+0xbc>
 804a02e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a031:	0f b6 10             	movzbl (%eax),%edx
 804a034:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a037:	0f b6 00             	movzbl (%eax),%eax
 804a03a:	38 c2                	cmp    %al,%dl
 804a03c:	0f 97 c0             	seta   %al
 804a03f:	0f b6 c0             	movzbl %al,%eax
 804a042:	eb 05                	jmp    804a049 <strcmp+0xc1>
 804a044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a049:	89 ec                	mov    %ebp,%esp
 804a04b:	5d                   	pop    %ebp
 804a04c:	c3                   	ret    

0804a04d <memchr>:
 804a04d:	55                   	push   %ebp
 804a04e:	89 e5                	mov    %esp,%ebp
 804a050:	83 ec 38             	sub    $0x38,%esp
 804a053:	8b 45 08             	mov    0x8(%ebp),%eax
 804a056:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a059:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a05c:	88 45 f3             	mov    %al,-0xd(%ebp)
 804a05f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 804a063:	75 45                	jne    804a0aa <memchr+0x5d>
 804a065:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 804a069:	74 3f                	je     804a0aa <memchr+0x5d>
 804a06b:	c7 44 24 10 e6 b7 04 	movl   $0x804b7e6,0x10(%esp)
 804a072:	08 
 804a073:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a07a:	08 
 804a07b:	c7 44 24 08 78 b8 04 	movl   $0x804b878,0x8(%esp)
 804a082:	08 
 804a083:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
 804a08a:	00 
 804a08b:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a092:	e8 c2 0a 00 00       	call   804ab59 <debug_panic>
 804a097:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a09a:	0f b6 00             	movzbl (%eax),%eax
 804a09d:	38 45 f3             	cmp    %al,-0xd(%ebp)
 804a0a0:	75 05                	jne    804a0a7 <memchr+0x5a>
 804a0a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a0a5:	eb 15                	jmp    804a0bc <memchr+0x6f>
 804a0a7:	ff 45 f4             	incl   -0xc(%ebp)
 804a0aa:	8b 45 10             	mov    0x10(%ebp),%eax
 804a0ad:	8d 50 ff             	lea    -0x1(%eax),%edx
 804a0b0:	89 55 10             	mov    %edx,0x10(%ebp)
 804a0b3:	85 c0                	test   %eax,%eax
 804a0b5:	75 e0                	jne    804a097 <memchr+0x4a>
 804a0b7:	b8 00 00 00 00       	mov    $0x0,%eax
 804a0bc:	89 ec                	mov    %ebp,%esp
 804a0be:	5d                   	pop    %ebp
 804a0bf:	c3                   	ret    

0804a0c0 <strchr>:
 804a0c0:	55                   	push   %ebp
 804a0c1:	89 e5                	mov    %esp,%ebp
 804a0c3:	83 ec 38             	sub    $0x38,%esp
 804a0c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a0c9:	88 45 f7             	mov    %al,-0x9(%ebp)
 804a0cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804a0d0:	75 2c                	jne    804a0fe <strchr+0x3e>
 804a0d2:	c7 44 24 10 01 b8 04 	movl   $0x804b801,0x10(%esp)
 804a0d9:	08 
 804a0da:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a0e1:	08 
 804a0e2:	c7 44 24 08 80 b8 04 	movl   $0x804b880,0x8(%esp)
 804a0e9:	08 
 804a0ea:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
 804a0f1:	00 
 804a0f2:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a0f9:	e8 5b 0a 00 00       	call   804ab59 <debug_panic>
 804a0fe:	8b 45 08             	mov    0x8(%ebp),%eax
 804a101:	0f b6 00             	movzbl (%eax),%eax
 804a104:	38 45 f7             	cmp    %al,-0x9(%ebp)
 804a107:	75 05                	jne    804a10e <strchr+0x4e>
 804a109:	8b 45 08             	mov    0x8(%ebp),%eax
 804a10c:	eb 16                	jmp    804a124 <strchr+0x64>
 804a10e:	8b 45 08             	mov    0x8(%ebp),%eax
 804a111:	0f b6 00             	movzbl (%eax),%eax
 804a114:	84 c0                	test   %al,%al
 804a116:	75 07                	jne    804a11f <strchr+0x5f>
 804a118:	b8 00 00 00 00       	mov    $0x0,%eax
 804a11d:	eb 05                	jmp    804a124 <strchr+0x64>
 804a11f:	ff 45 08             	incl   0x8(%ebp)
 804a122:	eb da                	jmp    804a0fe <strchr+0x3e>
 804a124:	89 ec                	mov    %ebp,%esp
 804a126:	5d                   	pop    %ebp
 804a127:	c3                   	ret    

0804a128 <strcspn>:
 804a128:	55                   	push   %ebp
 804a129:	89 e5                	mov    %esp,%ebp
 804a12b:	83 ec 28             	sub    $0x28,%esp
 804a12e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 804a135:	eb 24                	jmp    804a15b <strcspn+0x33>
 804a137:	8b 55 08             	mov    0x8(%ebp),%edx
 804a13a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a13d:	01 d0                	add    %edx,%eax
 804a13f:	0f b6 00             	movzbl (%eax),%eax
 804a142:	0f be c0             	movsbl %al,%eax
 804a145:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a149:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a14c:	89 04 24             	mov    %eax,(%esp)
 804a14f:	e8 6c ff ff ff       	call   804a0c0 <strchr>
 804a154:	85 c0                	test   %eax,%eax
 804a156:	75 14                	jne    804a16c <strcspn+0x44>
 804a158:	ff 45 f4             	incl   -0xc(%ebp)
 804a15b:	8b 55 08             	mov    0x8(%ebp),%edx
 804a15e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a161:	01 d0                	add    %edx,%eax
 804a163:	0f b6 00             	movzbl (%eax),%eax
 804a166:	84 c0                	test   %al,%al
 804a168:	75 cd                	jne    804a137 <strcspn+0xf>
 804a16a:	eb 01                	jmp    804a16d <strcspn+0x45>
 804a16c:	90                   	nop
 804a16d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a170:	89 ec                	mov    %ebp,%esp
 804a172:	5d                   	pop    %ebp
 804a173:	c3                   	ret    

0804a174 <strpbrk>:
 804a174:	55                   	push   %ebp
 804a175:	89 e5                	mov    %esp,%ebp
 804a177:	83 ec 18             	sub    $0x18,%esp
 804a17a:	eb 24                	jmp    804a1a0 <strpbrk+0x2c>
 804a17c:	8b 45 08             	mov    0x8(%ebp),%eax
 804a17f:	0f b6 00             	movzbl (%eax),%eax
 804a182:	0f be c0             	movsbl %al,%eax
 804a185:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a189:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a18c:	89 04 24             	mov    %eax,(%esp)
 804a18f:	e8 2c ff ff ff       	call   804a0c0 <strchr>
 804a194:	85 c0                	test   %eax,%eax
 804a196:	74 05                	je     804a19d <strpbrk+0x29>
 804a198:	8b 45 08             	mov    0x8(%ebp),%eax
 804a19b:	eb 12                	jmp    804a1af <strpbrk+0x3b>
 804a19d:	ff 45 08             	incl   0x8(%ebp)
 804a1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 804a1a3:	0f b6 00             	movzbl (%eax),%eax
 804a1a6:	84 c0                	test   %al,%al
 804a1a8:	75 d2                	jne    804a17c <strpbrk+0x8>
 804a1aa:	b8 00 00 00 00       	mov    $0x0,%eax
 804a1af:	89 ec                	mov    %ebp,%esp
 804a1b1:	5d                   	pop    %ebp
 804a1b2:	c3                   	ret    

0804a1b3 <strrchr>:
 804a1b3:	55                   	push   %ebp
 804a1b4:	89 e5                	mov    %esp,%ebp
 804a1b6:	83 ec 10             	sub    $0x10,%esp
 804a1b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a1bc:	88 45 fb             	mov    %al,-0x5(%ebp)
 804a1bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804a1c6:	eb 14                	jmp    804a1dc <strrchr+0x29>
 804a1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 804a1cb:	0f b6 00             	movzbl (%eax),%eax
 804a1ce:	38 45 fb             	cmp    %al,-0x5(%ebp)
 804a1d1:	75 06                	jne    804a1d9 <strrchr+0x26>
 804a1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 804a1d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804a1d9:	ff 45 08             	incl   0x8(%ebp)
 804a1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 804a1df:	0f b6 00             	movzbl (%eax),%eax
 804a1e2:	84 c0                	test   %al,%al
 804a1e4:	75 e2                	jne    804a1c8 <strrchr+0x15>
 804a1e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a1e9:	89 ec                	mov    %ebp,%esp
 804a1eb:	5d                   	pop    %ebp
 804a1ec:	c3                   	ret    

0804a1ed <strspn>:
 804a1ed:	55                   	push   %ebp
 804a1ee:	89 e5                	mov    %esp,%ebp
 804a1f0:	83 ec 28             	sub    $0x28,%esp
 804a1f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 804a1fa:	eb 24                	jmp    804a220 <strspn+0x33>
 804a1fc:	8b 55 08             	mov    0x8(%ebp),%edx
 804a1ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a202:	01 d0                	add    %edx,%eax
 804a204:	0f b6 00             	movzbl (%eax),%eax
 804a207:	0f be c0             	movsbl %al,%eax
 804a20a:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a20e:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a211:	89 04 24             	mov    %eax,(%esp)
 804a214:	e8 a7 fe ff ff       	call   804a0c0 <strchr>
 804a219:	85 c0                	test   %eax,%eax
 804a21b:	74 14                	je     804a231 <strspn+0x44>
 804a21d:	ff 45 f4             	incl   -0xc(%ebp)
 804a220:	8b 55 08             	mov    0x8(%ebp),%edx
 804a223:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a226:	01 d0                	add    %edx,%eax
 804a228:	0f b6 00             	movzbl (%eax),%eax
 804a22b:	84 c0                	test   %al,%al
 804a22d:	75 cd                	jne    804a1fc <strspn+0xf>
 804a22f:	eb 01                	jmp    804a232 <strspn+0x45>
 804a231:	90                   	nop
 804a232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a235:	89 ec                	mov    %ebp,%esp
 804a237:	5d                   	pop    %ebp
 804a238:	c3                   	ret    

0804a239 <strstr>:
 804a239:	55                   	push   %ebp
 804a23a:	89 e5                	mov    %esp,%ebp
 804a23c:	83 ec 28             	sub    $0x28,%esp
 804a23f:	8b 45 08             	mov    0x8(%ebp),%eax
 804a242:	89 04 24             	mov    %eax,(%esp)
 804a245:	e8 00 02 00 00       	call   804a44a <strlen>
 804a24a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804a24d:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a250:	89 04 24             	mov    %eax,(%esp)
 804a253:	e8 f2 01 00 00       	call   804a44a <strlen>
 804a258:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804a25b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a25e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 804a261:	72 43                	jb     804a2a6 <strstr+0x6d>
 804a263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 804a26a:	eb 2f                	jmp    804a29b <strstr+0x62>
 804a26c:	8b 55 08             	mov    0x8(%ebp),%edx
 804a26f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a272:	01 c2                	add    %eax,%edx
 804a274:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804a277:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a27e:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a282:	89 14 24             	mov    %edx,(%esp)
 804a285:	e8 32 fc ff ff       	call   8049ebc <memcmp>
 804a28a:	85 c0                	test   %eax,%eax
 804a28c:	75 0a                	jne    804a298 <strstr+0x5f>
 804a28e:	8b 55 08             	mov    0x8(%ebp),%edx
 804a291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a294:	01 d0                	add    %edx,%eax
 804a296:	eb 13                	jmp    804a2ab <strstr+0x72>
 804a298:	ff 45 f4             	incl   -0xc(%ebp)
 804a29b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a29e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 804a2a1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 804a2a4:	76 c6                	jbe    804a26c <strstr+0x33>
 804a2a6:	b8 00 00 00 00       	mov    $0x0,%eax
 804a2ab:	89 ec                	mov    %ebp,%esp
 804a2ad:	5d                   	pop    %ebp
 804a2ae:	c3                   	ret    

0804a2af <strtok_r>:
 804a2af:	55                   	push   %ebp
 804a2b0:	89 e5                	mov    %esp,%ebp
 804a2b2:	83 ec 38             	sub    $0x38,%esp
 804a2b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 804a2b9:	75 2c                	jne    804a2e7 <strtok_r+0x38>
 804a2bb:	c7 44 24 10 10 b8 04 	movl   $0x804b810,0x10(%esp)
 804a2c2:	08 
 804a2c3:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a2ca:	08 
 804a2cb:	c7 44 24 08 88 b8 04 	movl   $0x804b888,0x8(%esp)
 804a2d2:	08 
 804a2d3:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
 804a2da:	00 
 804a2db:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a2e2:	e8 72 08 00 00       	call   804ab59 <debug_panic>
 804a2e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 804a2eb:	75 2c                	jne    804a319 <strtok_r+0x6a>
 804a2ed:	c7 44 24 10 23 b8 04 	movl   $0x804b823,0x10(%esp)
 804a2f4:	08 
 804a2f5:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a2fc:	08 
 804a2fd:	c7 44 24 08 88 b8 04 	movl   $0x804b888,0x8(%esp)
 804a304:	08 
 804a305:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
 804a30c:	00 
 804a30d:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a314:	e8 40 08 00 00       	call   804ab59 <debug_panic>
 804a319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804a31d:	75 08                	jne    804a327 <strtok_r+0x78>
 804a31f:	8b 45 10             	mov    0x10(%ebp),%eax
 804a322:	8b 00                	mov    (%eax),%eax
 804a324:	89 45 08             	mov    %eax,0x8(%ebp)
 804a327:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804a32b:	75 48                	jne    804a375 <strtok_r+0xc6>
 804a32d:	c7 44 24 10 34 b8 04 	movl   $0x804b834,0x10(%esp)
 804a334:	08 
 804a335:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a33c:	08 
 804a33d:	c7 44 24 08 88 b8 04 	movl   $0x804b888,0x8(%esp)
 804a344:	08 
 804a345:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
 804a34c:	00 
 804a34d:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a354:	e8 00 08 00 00       	call   804ab59 <debug_panic>
 804a359:	8b 45 08             	mov    0x8(%ebp),%eax
 804a35c:	0f b6 00             	movzbl (%eax),%eax
 804a35f:	84 c0                	test   %al,%al
 804a361:	75 0f                	jne    804a372 <strtok_r+0xc3>
 804a363:	8b 45 10             	mov    0x10(%ebp),%eax
 804a366:	8b 55 08             	mov    0x8(%ebp),%edx
 804a369:	89 10                	mov    %edx,(%eax)
 804a36b:	b8 00 00 00 00       	mov    $0x0,%eax
 804a370:	eb 6e                	jmp    804a3e0 <strtok_r+0x131>
 804a372:	ff 45 08             	incl   0x8(%ebp)
 804a375:	8b 45 08             	mov    0x8(%ebp),%eax
 804a378:	0f b6 00             	movzbl (%eax),%eax
 804a37b:	0f be c0             	movsbl %al,%eax
 804a37e:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a382:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a385:	89 04 24             	mov    %eax,(%esp)
 804a388:	e8 33 fd ff ff       	call   804a0c0 <strchr>
 804a38d:	85 c0                	test   %eax,%eax
 804a38f:	75 c8                	jne    804a359 <strtok_r+0xaa>
 804a391:	8b 45 08             	mov    0x8(%ebp),%eax
 804a394:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a397:	eb 03                	jmp    804a39c <strtok_r+0xed>
 804a399:	ff 45 08             	incl   0x8(%ebp)
 804a39c:	8b 45 08             	mov    0x8(%ebp),%eax
 804a39f:	0f b6 00             	movzbl (%eax),%eax
 804a3a2:	0f be c0             	movsbl %al,%eax
 804a3a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a3ac:	89 04 24             	mov    %eax,(%esp)
 804a3af:	e8 0c fd ff ff       	call   804a0c0 <strchr>
 804a3b4:	85 c0                	test   %eax,%eax
 804a3b6:	74 e1                	je     804a399 <strtok_r+0xea>
 804a3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 804a3bb:	0f b6 00             	movzbl (%eax),%eax
 804a3be:	84 c0                	test   %al,%al
 804a3c0:	74 13                	je     804a3d5 <strtok_r+0x126>
 804a3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 804a3c5:	c6 00 00             	movb   $0x0,(%eax)
 804a3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 804a3cb:	8d 50 01             	lea    0x1(%eax),%edx
 804a3ce:	8b 45 10             	mov    0x10(%ebp),%eax
 804a3d1:	89 10                	mov    %edx,(%eax)
 804a3d3:	eb 08                	jmp    804a3dd <strtok_r+0x12e>
 804a3d5:	8b 45 10             	mov    0x10(%ebp),%eax
 804a3d8:	8b 55 08             	mov    0x8(%ebp),%edx
 804a3db:	89 10                	mov    %edx,(%eax)
 804a3dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a3e0:	89 ec                	mov    %ebp,%esp
 804a3e2:	5d                   	pop    %ebp
 804a3e3:	c3                   	ret    

0804a3e4 <memset>:
 804a3e4:	55                   	push   %ebp
 804a3e5:	89 e5                	mov    %esp,%ebp
 804a3e7:	83 ec 38             	sub    $0x38,%esp
 804a3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 804a3ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a3f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 804a3f4:	75 40                	jne    804a436 <memset+0x52>
 804a3f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 804a3fa:	74 3a                	je     804a436 <memset+0x52>
 804a3fc:	c7 44 24 10 48 b7 04 	movl   $0x804b748,0x10(%esp)
 804a403:	08 
 804a404:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a40b:	08 
 804a40c:	c7 44 24 08 94 b8 04 	movl   $0x804b894,0x8(%esp)
 804a413:	08 
 804a414:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
 804a41b:	00 
 804a41c:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a423:	e8 31 07 00 00       	call   804ab59 <debug_panic>
 804a428:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a42b:	8d 50 01             	lea    0x1(%eax),%edx
 804a42e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 804a431:	8b 55 0c             	mov    0xc(%ebp),%edx
 804a434:	88 10                	mov    %dl,(%eax)
 804a436:	8b 45 10             	mov    0x10(%ebp),%eax
 804a439:	8d 50 ff             	lea    -0x1(%eax),%edx
 804a43c:	89 55 10             	mov    %edx,0x10(%ebp)
 804a43f:	85 c0                	test   %eax,%eax
 804a441:	75 e5                	jne    804a428 <memset+0x44>
 804a443:	8b 45 08             	mov    0x8(%ebp),%eax
 804a446:	89 ec                	mov    %ebp,%esp
 804a448:	5d                   	pop    %ebp
 804a449:	c3                   	ret    

0804a44a <strlen>:
 804a44a:	55                   	push   %ebp
 804a44b:	89 e5                	mov    %esp,%ebp
 804a44d:	83 ec 38             	sub    $0x38,%esp
 804a450:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804a454:	75 2c                	jne    804a482 <strlen+0x38>
 804a456:	c7 44 24 10 01 b8 04 	movl   $0x804b801,0x10(%esp)
 804a45d:	08 
 804a45e:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a465:	08 
 804a466:	c7 44 24 08 9c b8 04 	movl   $0x804b89c,0x8(%esp)
 804a46d:	08 
 804a46e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
 804a475:	00 
 804a476:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a47d:	e8 d7 06 00 00       	call   804ab59 <debug_panic>
 804a482:	8b 45 08             	mov    0x8(%ebp),%eax
 804a485:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a488:	eb 04                	jmp    804a48e <strlen+0x44>
 804a48a:	90                   	nop
 804a48b:	ff 45 f4             	incl   -0xc(%ebp)
 804a48e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a491:	0f b6 00             	movzbl (%eax),%eax
 804a494:	84 c0                	test   %al,%al
 804a496:	75 f2                	jne    804a48a <strlen+0x40>
 804a498:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a49b:	2b 45 08             	sub    0x8(%ebp),%eax
 804a49e:	89 ec                	mov    %ebp,%esp
 804a4a0:	5d                   	pop    %ebp
 804a4a1:	c3                   	ret    

0804a4a2 <strnlen>:
 804a4a2:	55                   	push   %ebp
 804a4a3:	89 e5                	mov    %esp,%ebp
 804a4a5:	83 ec 10             	sub    $0x10,%esp
 804a4a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804a4af:	eb 04                	jmp    804a4b5 <strnlen+0x13>
 804a4b1:	90                   	nop
 804a4b2:	ff 45 fc             	incl   -0x4(%ebp)
 804a4b5:	8b 55 08             	mov    0x8(%ebp),%edx
 804a4b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a4bb:	01 d0                	add    %edx,%eax
 804a4bd:	0f b6 00             	movzbl (%eax),%eax
 804a4c0:	84 c0                	test   %al,%al
 804a4c2:	74 08                	je     804a4cc <strnlen+0x2a>
 804a4c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a4c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 804a4ca:	72 e5                	jb     804a4b1 <strnlen+0xf>
 804a4cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a4cf:	89 ec                	mov    %ebp,%esp
 804a4d1:	5d                   	pop    %ebp
 804a4d2:	c3                   	ret    

0804a4d3 <strlcpy>:
 804a4d3:	55                   	push   %ebp
 804a4d4:	89 e5                	mov    %esp,%ebp
 804a4d6:	83 ec 38             	sub    $0x38,%esp
 804a4d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804a4dd:	75 2c                	jne    804a50b <strlcpy+0x38>
 804a4df:	c7 44 24 10 3e b8 04 	movl   $0x804b83e,0x10(%esp)
 804a4e6:	08 
 804a4e7:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a4ee:	08 
 804a4ef:	c7 44 24 08 a4 b8 04 	movl   $0x804b8a4,0x8(%esp)
 804a4f6:	08 
 804a4f7:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
 804a4fe:	00 
 804a4ff:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a506:	e8 4e 06 00 00       	call   804ab59 <debug_panic>
 804a50b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 804a50f:	75 2c                	jne    804a53d <strlcpy+0x6a>
 804a511:	c7 44 24 10 4a b8 04 	movl   $0x804b84a,0x10(%esp)
 804a518:	08 
 804a519:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a520:	08 
 804a521:	c7 44 24 08 a4 b8 04 	movl   $0x804b8a4,0x8(%esp)
 804a528:	08 
 804a529:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
 804a530:	00 
 804a531:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a538:	e8 1c 06 00 00       	call   804ab59 <debug_panic>
 804a53d:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a540:	89 04 24             	mov    %eax,(%esp)
 804a543:	e8 02 ff ff ff       	call   804a44a <strlen>
 804a548:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804a54b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 804a54f:	74 39                	je     804a58a <strlcpy+0xb7>
 804a551:	8b 45 10             	mov    0x10(%ebp),%eax
 804a554:	48                   	dec    %eax
 804a555:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a558:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a55b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 804a55e:	73 06                	jae    804a566 <strlcpy+0x93>
 804a560:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a563:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a566:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a569:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a56d:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a570:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a574:	8b 45 08             	mov    0x8(%ebp),%eax
 804a577:	89 04 24             	mov    %eax,(%esp)
 804a57a:	e8 ab f7 ff ff       	call   8049d2a <memcpy>
 804a57f:	8b 55 08             	mov    0x8(%ebp),%edx
 804a582:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a585:	01 d0                	add    %edx,%eax
 804a587:	c6 00 00             	movb   $0x0,(%eax)
 804a58a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a58d:	89 ec                	mov    %ebp,%esp
 804a58f:	5d                   	pop    %ebp
 804a590:	c3                   	ret    

0804a591 <strlcat>:
 804a591:	55                   	push   %ebp
 804a592:	89 e5                	mov    %esp,%ebp
 804a594:	83 ec 38             	sub    $0x38,%esp
 804a597:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804a59b:	75 2c                	jne    804a5c9 <strlcat+0x38>
 804a59d:	c7 44 24 10 3e b8 04 	movl   $0x804b83e,0x10(%esp)
 804a5a4:	08 
 804a5a5:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a5ac:	08 
 804a5ad:	c7 44 24 08 ac b8 04 	movl   $0x804b8ac,0x8(%esp)
 804a5b4:	08 
 804a5b5:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
 804a5bc:	00 
 804a5bd:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a5c4:	e8 90 05 00 00       	call   804ab59 <debug_panic>
 804a5c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 804a5cd:	75 2c                	jne    804a5fb <strlcat+0x6a>
 804a5cf:	c7 44 24 10 4a b8 04 	movl   $0x804b84a,0x10(%esp)
 804a5d6:	08 
 804a5d7:	c7 44 24 0c 61 b7 04 	movl   $0x804b761,0xc(%esp)
 804a5de:	08 
 804a5df:	c7 44 24 08 ac b8 04 	movl   $0x804b8ac,0x8(%esp)
 804a5e6:	08 
 804a5e7:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
 804a5ee:	00 
 804a5ef:	c7 04 24 78 b7 04 08 	movl   $0x804b778,(%esp)
 804a5f6:	e8 5e 05 00 00       	call   804ab59 <debug_panic>
 804a5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a5fe:	89 04 24             	mov    %eax,(%esp)
 804a601:	e8 44 fe ff ff       	call   804a44a <strlen>
 804a606:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804a609:	8b 45 08             	mov    0x8(%ebp),%eax
 804a60c:	89 04 24             	mov    %eax,(%esp)
 804a60f:	e8 36 fe ff ff       	call   804a44a <strlen>
 804a614:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804a617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 804a61b:	74 4e                	je     804a66b <strlcat+0xda>
 804a61d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804a620:	3b 45 10             	cmp    0x10(%ebp),%eax
 804a623:	73 46                	jae    804a66b <strlcat+0xda>
 804a625:	8b 45 10             	mov    0x10(%ebp),%eax
 804a628:	2b 45 ec             	sub    -0x14(%ebp),%eax
 804a62b:	48                   	dec    %eax
 804a62c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a62f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a632:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 804a635:	73 06                	jae    804a63d <strlcat+0xac>
 804a637:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a63a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a63d:	8b 55 08             	mov    0x8(%ebp),%edx
 804a640:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804a643:	01 c2                	add    %eax,%edx
 804a645:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a648:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a64c:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a64f:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a653:	89 14 24             	mov    %edx,(%esp)
 804a656:	e8 cf f6 ff ff       	call   8049d2a <memcpy>
 804a65b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804a65e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a661:	01 c2                	add    %eax,%edx
 804a663:	8b 45 08             	mov    0x8(%ebp),%eax
 804a666:	01 d0                	add    %edx,%eax
 804a668:	c6 00 00             	movb   $0x0,(%eax)
 804a66b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 804a66e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804a671:	01 d0                	add    %edx,%eax
 804a673:	89 ec                	mov    %ebp,%esp
 804a675:	5d                   	pop    %ebp
 804a676:	c3                   	ret    

0804a677 <divl>:
 804a677:	55                   	push   %ebp
 804a678:	89 e5                	mov    %esp,%ebp
 804a67a:	83 ec 18             	sub    $0x18,%esp
 804a67d:	8b 45 08             	mov    0x8(%ebp),%eax
 804a680:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804a683:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a686:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804a689:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804a68c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804a68f:	89 d0                	mov    %edx,%eax
 804a691:	31 d2                	xor    %edx,%edx
 804a693:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804a696:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804a699:	89 45 f8             	mov    %eax,-0x8(%ebp)
 804a69c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 804a69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804a6a2:	f7 75 10             	divl   0x10(%ebp)
 804a6a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 804a6a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804a6ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a6ae:	89 ec                	mov    %ebp,%esp
 804a6b0:	5d                   	pop    %ebp
 804a6b1:	c3                   	ret    

0804a6b2 <nlz>:
 804a6b2:	55                   	push   %ebp
 804a6b3:	89 e5                	mov    %esp,%ebp
 804a6b5:	83 ec 10             	sub    $0x10,%esp
 804a6b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804a6bf:	81 7d 08 ff ff 00 00 	cmpl   $0xffff,0x8(%ebp)
 804a6c6:	77 08                	ja     804a6d0 <nlz+0x1e>
 804a6c8:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
 804a6cc:	c1 65 08 10          	shll   $0x10,0x8(%ebp)
 804a6d0:	81 7d 08 ff ff ff 00 	cmpl   $0xffffff,0x8(%ebp)
 804a6d7:	77 08                	ja     804a6e1 <nlz+0x2f>
 804a6d9:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
 804a6dd:	c1 65 08 08          	shll   $0x8,0x8(%ebp)
 804a6e1:	81 7d 08 ff ff ff 0f 	cmpl   $0xfffffff,0x8(%ebp)
 804a6e8:	77 08                	ja     804a6f2 <nlz+0x40>
 804a6ea:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
 804a6ee:	c1 65 08 04          	shll   $0x4,0x8(%ebp)
 804a6f2:	81 7d 08 ff ff ff 3f 	cmpl   $0x3fffffff,0x8(%ebp)
 804a6f9:	77 08                	ja     804a703 <nlz+0x51>
 804a6fb:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
 804a6ff:	c1 65 08 02          	shll   $0x2,0x8(%ebp)
 804a703:	8b 45 08             	mov    0x8(%ebp),%eax
 804a706:	85 c0                	test   %eax,%eax
 804a708:	78 03                	js     804a70d <nlz+0x5b>
 804a70a:	ff 45 fc             	incl   -0x4(%ebp)
 804a70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a710:	89 ec                	mov    %ebp,%esp
 804a712:	5d                   	pop    %ebp
 804a713:	c3                   	ret    

0804a714 <udiv64>:
 804a714:	55                   	push   %ebp
 804a715:	89 e5                	mov    %esp,%ebp
 804a717:	57                   	push   %edi
 804a718:	56                   	push   %esi
 804a719:	53                   	push   %ebx
 804a71a:	83 ec 54             	sub    $0x54,%esp
 804a71d:	8b 45 08             	mov    0x8(%ebp),%eax
 804a720:	89 45 b8             	mov    %eax,-0x48(%ebp)
 804a723:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a726:	89 45 bc             	mov    %eax,-0x44(%ebp)
 804a729:	8b 45 10             	mov    0x10(%ebp),%eax
 804a72c:	89 45 b0             	mov    %eax,-0x50(%ebp)
 804a72f:	8b 45 14             	mov    0x14(%ebp),%eax
 804a732:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 804a735:	8b 45 b0             	mov    -0x50(%ebp),%eax
 804a738:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 804a73b:	89 d0                	mov    %edx,%eax
 804a73d:	31 d2                	xor    %edx,%edx
 804a73f:	89 c7                	mov    %eax,%edi
 804a741:	83 f7 00             	xor    $0x0,%edi
 804a744:	89 f9                	mov    %edi,%ecx
 804a746:	89 d0                	mov    %edx,%eax
 804a748:	83 f0 00             	xor    $0x0,%eax
 804a74b:	89 c3                	mov    %eax,%ebx
 804a74d:	89 d8                	mov    %ebx,%eax
 804a74f:	09 c8                	or     %ecx,%eax
 804a751:	85 c0                	test   %eax,%eax
 804a753:	0f 85 a6 00 00 00    	jne    804a7ff <udiv64+0xeb>
 804a759:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 804a760:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
 804a767:	8b 45 b8             	mov    -0x48(%ebp),%eax
 804a76a:	8b 55 bc             	mov    -0x44(%ebp),%edx
 804a76d:	89 d0                	mov    %edx,%eax
 804a76f:	31 d2                	xor    %edx,%edx
 804a771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 804a774:	8b 45 b8             	mov    -0x48(%ebp),%eax
 804a777:	89 45 d0             	mov    %eax,-0x30(%ebp)
 804a77a:	8b 45 b0             	mov    -0x50(%ebp),%eax
 804a77d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 804a780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 804a783:	ba 00 00 00 00       	mov    $0x0,%edx
 804a788:	f7 75 cc             	divl   -0x34(%ebp)
 804a78b:	89 d0                	mov    %edx,%eax
 804a78d:	ba 00 00 00 00       	mov    $0x0,%edx
 804a792:	8b 4d d8             	mov    -0x28(%ebp),%ecx
 804a795:	89 cb                	mov    %ecx,%ebx
 804a797:	0f af da             	imul   %edx,%ebx
 804a79a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 804a79d:	0f af c8             	imul   %eax,%ecx
 804a7a0:	01 d9                	add    %ebx,%ecx
 804a7a2:	f7 65 d8             	mull   -0x28(%ebp)
 804a7a5:	01 d1                	add    %edx,%ecx
 804a7a7:	89 ca                	mov    %ecx,%edx
 804a7a9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 804a7ac:	bb 00 00 00 00       	mov    $0x0,%ebx
 804a7b1:	01 c8                	add    %ecx,%eax
 804a7b3:	11 da                	adc    %ebx,%edx
 804a7b5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 804a7b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 804a7bc:	89 04 24             	mov    %eax,(%esp)
 804a7bf:	89 54 24 04          	mov    %edx,0x4(%esp)
 804a7c3:	e8 af fe ff ff       	call   804a677 <divl>
 804a7c8:	89 c6                	mov    %eax,%esi
 804a7ca:	bf 00 00 00 00       	mov    $0x0,%edi
 804a7cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 804a7d2:	ba 00 00 00 00       	mov    $0x0,%edx
 804a7d7:	f7 75 cc             	divl   -0x34(%ebp)
 804a7da:	ba 00 00 00 00       	mov    $0x0,%edx
 804a7df:	8b 4d d8             	mov    -0x28(%ebp),%ecx
 804a7e2:	89 cb                	mov    %ecx,%ebx
 804a7e4:	0f af da             	imul   %edx,%ebx
 804a7e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 804a7ea:	0f af c8             	imul   %eax,%ecx
 804a7ed:	01 d9                	add    %ebx,%ecx
 804a7ef:	f7 65 d8             	mull   -0x28(%ebp)
 804a7f2:	01 d1                	add    %edx,%ecx
 804a7f4:	89 ca                	mov    %ecx,%edx
 804a7f6:	01 f0                	add    %esi,%eax
 804a7f8:	11 fa                	adc    %edi,%edx
 804a7fa:	e9 de 00 00 00       	jmp    804a8dd <udiv64+0x1c9>
 804a7ff:	8b 45 b8             	mov    -0x48(%ebp),%eax
 804a802:	8b 55 bc             	mov    -0x44(%ebp),%edx
 804a805:	3b 45 b0             	cmp    -0x50(%ebp),%eax
 804a808:	89 d0                	mov    %edx,%eax
 804a80a:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
 804a80d:	73 0f                	jae    804a81e <udiv64+0x10a>
 804a80f:	b8 00 00 00 00       	mov    $0x0,%eax
 804a814:	ba 00 00 00 00       	mov    $0x0,%edx
 804a819:	e9 bf 00 00 00       	jmp    804a8dd <udiv64+0x1c9>
 804a81e:	8b 45 b0             	mov    -0x50(%ebp),%eax
 804a821:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 804a824:	89 d0                	mov    %edx,%eax
 804a826:	31 d2                	xor    %edx,%edx
 804a828:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804a82b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804a82e:	89 04 24             	mov    %eax,(%esp)
 804a831:	e8 7c fe ff ff       	call   804a6b2 <nlz>
 804a836:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804a839:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 804a83c:	8b 45 b0             	mov    -0x50(%ebp),%eax
 804a83f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 804a842:	0f a5 c2             	shld   %cl,%eax,%edx
 804a845:	d3 e0                	shl    %cl,%eax
 804a847:	f6 c1 20             	test   $0x20,%cl
 804a84a:	74 04                	je     804a850 <udiv64+0x13c>
 804a84c:	89 c2                	mov    %eax,%edx
 804a84e:	31 c0                	xor    %eax,%eax
 804a850:	89 d0                	mov    %edx,%eax
 804a852:	31 d2                	xor    %edx,%edx
 804a854:	89 c1                	mov    %eax,%ecx
 804a856:	8b 45 b8             	mov    -0x48(%ebp),%eax
 804a859:	8b 55 bc             	mov    -0x44(%ebp),%edx
 804a85c:	0f ac d0 01          	shrd   $0x1,%edx,%eax
 804a860:	d1 ea                	shr    %edx
 804a862:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 804a866:	89 04 24             	mov    %eax,(%esp)
 804a869:	89 54 24 04          	mov    %edx,0x4(%esp)
 804a86d:	e8 05 fe ff ff       	call   804a677 <divl>
 804a872:	89 c2                	mov    %eax,%edx
 804a874:	b8 1f 00 00 00       	mov    $0x1f,%eax
 804a879:	2b 45 e8             	sub    -0x18(%ebp),%eax
 804a87c:	88 c1                	mov    %al,%cl
 804a87e:	d3 ea                	shr    %cl,%edx
 804a880:	89 d0                	mov    %edx,%eax
 804a882:	89 45 e0             	mov    %eax,-0x20(%ebp)
 804a885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 804a88c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804a88f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 804a892:	83 c0 ff             	add    $0xffffffff,%eax
 804a895:	83 d2 ff             	adc    $0xffffffff,%edx
 804a898:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 804a89b:	89 cb                	mov    %ecx,%ebx
 804a89d:	0f af da             	imul   %edx,%ebx
 804a8a0:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 804a8a3:	0f af c8             	imul   %eax,%ecx
 804a8a6:	8d 34 0b             	lea    (%ebx,%ecx,1),%esi
 804a8a9:	f7 65 b0             	mull   -0x50(%ebp)
 804a8ac:	89 c1                	mov    %eax,%ecx
 804a8ae:	89 d3                	mov    %edx,%ebx
 804a8b0:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
 804a8b3:	89 c3                	mov    %eax,%ebx
 804a8b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
 804a8b8:	8b 55 bc             	mov    -0x44(%ebp),%edx
 804a8bb:	29 c8                	sub    %ecx,%eax
 804a8bd:	19 da                	sbb    %ebx,%edx
 804a8bf:	3b 45 b0             	cmp    -0x50(%ebp),%eax
 804a8c2:	89 d0                	mov    %edx,%eax
 804a8c4:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
 804a8c7:	73 0e                	jae    804a8d7 <udiv64+0x1c3>
 804a8c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804a8cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 804a8cf:	83 c0 ff             	add    $0xffffffff,%eax
 804a8d2:	83 d2 ff             	adc    $0xffffffff,%edx
 804a8d5:	eb 06                	jmp    804a8dd <udiv64+0x1c9>
 804a8d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804a8da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 804a8dd:	83 c4 54             	add    $0x54,%esp
 804a8e0:	5b                   	pop    %ebx
 804a8e1:	5e                   	pop    %esi
 804a8e2:	5f                   	pop    %edi
 804a8e3:	5d                   	pop    %ebp
 804a8e4:	c3                   	ret    

0804a8e5 <umod64>:
 804a8e5:	55                   	push   %ebp
 804a8e6:	89 e5                	mov    %esp,%ebp
 804a8e8:	83 ec 28             	sub    $0x28,%esp
 804a8eb:	89 5d fc             	mov    %ebx,-0x4(%ebp)
 804a8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 804a8f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804a8f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a8f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a8fa:	8b 45 10             	mov    0x10(%ebp),%eax
 804a8fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804a900:	8b 45 14             	mov    0x14(%ebp),%eax
 804a903:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804a906:	8b 5d f0             	mov    -0x10(%ebp),%ebx
 804a909:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804a90c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804a90f:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a913:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804a917:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a91a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804a91d:	89 04 24             	mov    %eax,(%esp)
 804a920:	89 54 24 04          	mov    %edx,0x4(%esp)
 804a924:	e8 eb fd ff ff       	call   804a714 <udiv64>
 804a929:	89 c2                	mov    %eax,%edx
 804a92b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804a92e:	0f af d0             	imul   %eax,%edx
 804a931:	89 d8                	mov    %ebx,%eax
 804a933:	29 d0                	sub    %edx,%eax
 804a935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 804a938:	89 ec                	mov    %ebp,%esp
 804a93a:	5d                   	pop    %ebp
 804a93b:	c3                   	ret    

0804a93c <sdiv64>:
 804a93c:	55                   	push   %ebp
 804a93d:	89 e5                	mov    %esp,%ebp
 804a93f:	57                   	push   %edi
 804a940:	56                   	push   %esi
 804a941:	83 ec 40             	sub    $0x40,%esp
 804a944:	8b 45 08             	mov    0x8(%ebp),%eax
 804a947:	89 45 d0             	mov    %eax,-0x30(%ebp)
 804a94a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a94d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 804a950:	8b 45 10             	mov    0x10(%ebp),%eax
 804a953:	89 45 c8             	mov    %eax,-0x38(%ebp)
 804a956:	8b 45 14             	mov    0x14(%ebp),%eax
 804a959:	89 45 cc             	mov    %eax,-0x34(%ebp)
 804a95c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804a960:	79 0f                	jns    804a971 <sdiv64+0x35>
 804a962:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804a965:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 804a968:	f7 d8                	neg    %eax
 804a96a:	83 d2 00             	adc    $0x0,%edx
 804a96d:	f7 da                	neg    %edx
 804a96f:	eb 06                	jmp    804a977 <sdiv64+0x3b>
 804a971:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804a974:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 804a977:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804a97a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 804a97d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
 804a981:	79 0f                	jns    804a992 <sdiv64+0x56>
 804a983:	8b 45 c8             	mov    -0x38(%ebp),%eax
 804a986:	8b 55 cc             	mov    -0x34(%ebp),%edx
 804a989:	f7 d8                	neg    %eax
 804a98b:	83 d2 00             	adc    $0x0,%edx
 804a98e:	f7 da                	neg    %edx
 804a990:	eb 06                	jmp    804a998 <sdiv64+0x5c>
 804a992:	8b 45 c8             	mov    -0x38(%ebp),%eax
 804a995:	8b 55 cc             	mov    -0x34(%ebp),%edx
 804a998:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804a99b:	89 55 ec             	mov    %edx,-0x14(%ebp)
 804a99e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804a9a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804a9a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a9a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804a9ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a9af:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804a9b2:	89 04 24             	mov    %eax,(%esp)
 804a9b5:	89 54 24 04          	mov    %edx,0x4(%esp)
 804a9b9:	e8 56 fd ff ff       	call   804a714 <udiv64>
 804a9be:	89 45 e0             	mov    %eax,-0x20(%ebp)
 804a9c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 804a9c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804a9c7:	33 45 c8             	xor    -0x38(%ebp),%eax
 804a9ca:	89 c6                	mov    %eax,%esi
 804a9cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 804a9cf:	33 45 cc             	xor    -0x34(%ebp),%eax
 804a9d2:	89 c7                	mov    %eax,%edi
 804a9d4:	85 ff                	test   %edi,%edi
 804a9d6:	79 0f                	jns    804a9e7 <sdiv64+0xab>
 804a9d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804a9db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 804a9de:	f7 d8                	neg    %eax
 804a9e0:	83 d2 00             	adc    $0x0,%edx
 804a9e3:	f7 da                	neg    %edx
 804a9e5:	eb 06                	jmp    804a9ed <sdiv64+0xb1>
 804a9e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804a9ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 804a9ed:	83 c4 40             	add    $0x40,%esp
 804a9f0:	5e                   	pop    %esi
 804a9f1:	5f                   	pop    %edi
 804a9f2:	5d                   	pop    %ebp
 804a9f3:	c3                   	ret    

0804a9f4 <smod64>:
 804a9f4:	55                   	push   %ebp
 804a9f5:	89 e5                	mov    %esp,%ebp
 804a9f7:	83 ec 28             	sub    $0x28,%esp
 804a9fa:	89 5d fc             	mov    %ebx,-0x4(%ebp)
 804a9fd:	8b 45 08             	mov    0x8(%ebp),%eax
 804aa00:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804aa03:	8b 45 0c             	mov    0xc(%ebp),%eax
 804aa06:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804aa09:	8b 45 10             	mov    0x10(%ebp),%eax
 804aa0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804aa0f:	8b 45 14             	mov    0x14(%ebp),%eax
 804aa12:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804aa15:	8b 5d f0             	mov    -0x10(%ebp),%ebx
 804aa18:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804aa1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804aa1e:	89 44 24 08          	mov    %eax,0x8(%esp)
 804aa22:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804aa26:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804aa29:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804aa2c:	89 04 24             	mov    %eax,(%esp)
 804aa2f:	89 54 24 04          	mov    %edx,0x4(%esp)
 804aa33:	e8 04 ff ff ff       	call   804a93c <sdiv64>
 804aa38:	89 c2                	mov    %eax,%edx
 804aa3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804aa3d:	0f af d0             	imul   %eax,%edx
 804aa40:	89 d8                	mov    %ebx,%eax
 804aa42:	29 d0                	sub    %edx,%eax
 804aa44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 804aa47:	89 ec                	mov    %ebp,%esp
 804aa49:	5d                   	pop    %ebp
 804aa4a:	c3                   	ret    

0804aa4b <__divdi3>:
 804aa4b:	55                   	push   %ebp
 804aa4c:	89 e5                	mov    %esp,%ebp
 804aa4e:	83 ec 20             	sub    $0x20,%esp
 804aa51:	8b 45 08             	mov    0x8(%ebp),%eax
 804aa54:	89 45 f8             	mov    %eax,-0x8(%ebp)
 804aa57:	8b 45 0c             	mov    0xc(%ebp),%eax
 804aa5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804aa5d:	8b 45 10             	mov    0x10(%ebp),%eax
 804aa60:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804aa63:	8b 45 14             	mov    0x14(%ebp),%eax
 804aa66:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804aa69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804aa6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804aa6f:	89 44 24 08          	mov    %eax,0x8(%esp)
 804aa73:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804aa77:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804aa7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 804aa7d:	89 04 24             	mov    %eax,(%esp)
 804aa80:	89 54 24 04          	mov    %edx,0x4(%esp)
 804aa84:	e8 b3 fe ff ff       	call   804a93c <sdiv64>
 804aa89:	89 ec                	mov    %ebp,%esp
 804aa8b:	5d                   	pop    %ebp
 804aa8c:	c3                   	ret    

0804aa8d <__moddi3>:
 804aa8d:	55                   	push   %ebp
 804aa8e:	89 e5                	mov    %esp,%ebp
 804aa90:	83 ec 20             	sub    $0x20,%esp
 804aa93:	8b 45 08             	mov    0x8(%ebp),%eax
 804aa96:	89 45 f8             	mov    %eax,-0x8(%ebp)
 804aa99:	8b 45 0c             	mov    0xc(%ebp),%eax
 804aa9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804aa9f:	8b 45 10             	mov    0x10(%ebp),%eax
 804aaa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804aaa5:	8b 45 14             	mov    0x14(%ebp),%eax
 804aaa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804aaab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804aaae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804aab1:	89 44 24 08          	mov    %eax,0x8(%esp)
 804aab5:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804aab9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804aabc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 804aabf:	89 04 24             	mov    %eax,(%esp)
 804aac2:	89 54 24 04          	mov    %edx,0x4(%esp)
 804aac6:	e8 29 ff ff ff       	call   804a9f4 <smod64>
 804aacb:	99                   	cltd   
 804aacc:	89 ec                	mov    %ebp,%esp
 804aace:	5d                   	pop    %ebp
 804aacf:	c3                   	ret    

0804aad0 <__udivdi3>:
 804aad0:	55                   	push   %ebp
 804aad1:	89 e5                	mov    %esp,%ebp
 804aad3:	83 ec 20             	sub    $0x20,%esp
 804aad6:	8b 45 08             	mov    0x8(%ebp),%eax
 804aad9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 804aadc:	8b 45 0c             	mov    0xc(%ebp),%eax
 804aadf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804aae2:	8b 45 10             	mov    0x10(%ebp),%eax
 804aae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804aae8:	8b 45 14             	mov    0x14(%ebp),%eax
 804aaeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804aaee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804aaf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804aaf4:	89 44 24 08          	mov    %eax,0x8(%esp)
 804aaf8:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804aafc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804aaff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 804ab02:	89 04 24             	mov    %eax,(%esp)
 804ab05:	89 54 24 04          	mov    %edx,0x4(%esp)
 804ab09:	e8 06 fc ff ff       	call   804a714 <udiv64>
 804ab0e:	89 ec                	mov    %ebp,%esp
 804ab10:	5d                   	pop    %ebp
 804ab11:	c3                   	ret    

0804ab12 <__umoddi3>:
 804ab12:	55                   	push   %ebp
 804ab13:	89 e5                	mov    %esp,%ebp
 804ab15:	83 ec 20             	sub    $0x20,%esp
 804ab18:	8b 45 08             	mov    0x8(%ebp),%eax
 804ab1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 804ab1e:	8b 45 0c             	mov    0xc(%ebp),%eax
 804ab21:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ab24:	8b 45 10             	mov    0x10(%ebp),%eax
 804ab27:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804ab2a:	8b 45 14             	mov    0x14(%ebp),%eax
 804ab2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804ab30:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804ab33:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804ab36:	89 44 24 08          	mov    %eax,0x8(%esp)
 804ab3a:	89 54 24 0c          	mov    %edx,0xc(%esp)
 804ab3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804ab41:	8b 55 fc             	mov    -0x4(%ebp),%edx
 804ab44:	89 04 24             	mov    %eax,(%esp)
 804ab47:	89 54 24 04          	mov    %edx,0x4(%esp)
 804ab4b:	e8 95 fd ff ff       	call   804a8e5 <umod64>
 804ab50:	ba 00 00 00 00       	mov    $0x0,%edx
 804ab55:	89 ec                	mov    %ebp,%esp
 804ab57:	5d                   	pop    %ebp
 804ab58:	c3                   	ret    

0804ab59 <debug_panic>:
 804ab59:	55                   	push   %ebp
 804ab5a:	89 e5                	mov    %esp,%ebp
 804ab5c:	83 ec 28             	sub    $0x28,%esp
 804ab5f:	8b 45 10             	mov    0x10(%ebp),%eax
 804ab62:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804ab66:	8b 45 0c             	mov    0xc(%ebp),%eax
 804ab69:	89 44 24 08          	mov    %eax,0x8(%esp)
 804ab6d:	8b 45 08             	mov    0x8(%ebp),%eax
 804ab70:	89 44 24 04          	mov    %eax,0x4(%esp)
 804ab74:	c7 04 24 b4 b8 04 08 	movl   $0x804b8b4,(%esp)
 804ab7b:	e8 7e e0 ff ff       	call   8048bfe <printf>
 804ab80:	8d 45 18             	lea    0x18(%ebp),%eax
 804ab83:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804ab86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804ab89:	89 44 24 04          	mov    %eax,0x4(%esp)
 804ab8d:	8b 45 14             	mov    0x14(%ebp),%eax
 804ab90:	89 04 24             	mov    %eax,(%esp)
 804ab93:	e8 dd 04 00 00       	call   804b075 <vprintf>
 804ab98:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 804ab9f:	e8 61 05 00 00       	call   804b105 <putchar>
 804aba4:	e8 73 06 00 00       	call   804b21c <debug_backtrace>
 804aba9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804abb0:	e8 4e 00 00 00       	call   804ac03 <exit>

0804abb5 <practice>:
 804abb5:	55                   	push   %ebp
 804abb6:	89 e5                	mov    %esp,%ebp
 804abb8:	83 ec 10             	sub    $0x10,%esp
 804abbb:	ff 75 08             	push   0x8(%ebp)
 804abbe:	6a 0d                	push   $0xd
 804abc0:	cd 30                	int    $0x30
 804abc2:	83 c4 08             	add    $0x8,%esp
 804abc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804abc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804abcb:	89 ec                	mov    %ebp,%esp
 804abcd:	5d                   	pop    %ebp
 804abce:	c3                   	ret    

0804abcf <halt>:
 804abcf:	55                   	push   %ebp
 804abd0:	89 e5                	mov    %esp,%ebp
 804abd2:	83 ec 28             	sub    $0x28,%esp
 804abd5:	6a 00                	push   $0x0
 804abd7:	cd 30                	int    $0x30
 804abd9:	83 c4 04             	add    $0x4,%esp
 804abdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804abdf:	c7 44 24 0c dc b8 04 	movl   $0x804b8dc,0xc(%esp)
 804abe6:	08 
 804abe7:	c7 44 24 08 18 b9 04 	movl   $0x804b918,0x8(%esp)
 804abee:	08 
 804abef:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
 804abf6:	00 
 804abf7:	c7 04 24 fe b8 04 08 	movl   $0x804b8fe,(%esp)
 804abfe:	e8 56 ff ff ff       	call   804ab59 <debug_panic>

0804ac03 <exit>:
 804ac03:	55                   	push   %ebp
 804ac04:	89 e5                	mov    %esp,%ebp
 804ac06:	83 ec 28             	sub    $0x28,%esp
 804ac09:	ff 75 08             	push   0x8(%ebp)
 804ac0c:	6a 01                	push   $0x1
 804ac0e:	cd 30                	int    $0x30
 804ac10:	83 c4 08             	add    $0x8,%esp
 804ac13:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804ac16:	c7 44 24 0c dc b8 04 	movl   $0x804b8dc,0xc(%esp)
 804ac1d:	08 
 804ac1e:	c7 44 24 08 20 b9 04 	movl   $0x804b920,0x8(%esp)
 804ac25:	08 
 804ac26:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
 804ac2d:	00 
 804ac2e:	c7 04 24 fe b8 04 08 	movl   $0x804b8fe,(%esp)
 804ac35:	e8 1f ff ff ff       	call   804ab59 <debug_panic>

0804ac3a <exec>:
 804ac3a:	55                   	push   %ebp
 804ac3b:	89 e5                	mov    %esp,%ebp
 804ac3d:	83 ec 10             	sub    $0x10,%esp
 804ac40:	ff 75 08             	push   0x8(%ebp)
 804ac43:	6a 02                	push   $0x2
 804ac45:	cd 30                	int    $0x30
 804ac47:	83 c4 08             	add    $0x8,%esp
 804ac4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ac4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ac50:	89 ec                	mov    %ebp,%esp
 804ac52:	5d                   	pop    %ebp
 804ac53:	c3                   	ret    

0804ac54 <wait>:
 804ac54:	55                   	push   %ebp
 804ac55:	89 e5                	mov    %esp,%ebp
 804ac57:	83 ec 10             	sub    $0x10,%esp
 804ac5a:	ff 75 08             	push   0x8(%ebp)
 804ac5d:	6a 03                	push   $0x3
 804ac5f:	cd 30                	int    $0x30
 804ac61:	83 c4 08             	add    $0x8,%esp
 804ac64:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ac67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ac6a:	89 ec                	mov    %ebp,%esp
 804ac6c:	5d                   	pop    %ebp
 804ac6d:	c3                   	ret    

0804ac6e <create>:
 804ac6e:	55                   	push   %ebp
 804ac6f:	89 e5                	mov    %esp,%ebp
 804ac71:	83 ec 10             	sub    $0x10,%esp
 804ac74:	8b 45 08             	mov    0x8(%ebp),%eax
 804ac77:	8b 55 0c             	mov    0xc(%ebp),%edx
 804ac7a:	52                   	push   %edx
 804ac7b:	50                   	push   %eax
 804ac7c:	6a 04                	push   $0x4
 804ac7e:	cd 30                	int    $0x30
 804ac80:	83 c4 0c             	add    $0xc,%esp
 804ac83:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ac86:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ac89:	85 c0                	test   %eax,%eax
 804ac8b:	0f 95 c0             	setne  %al
 804ac8e:	89 ec                	mov    %ebp,%esp
 804ac90:	5d                   	pop    %ebp
 804ac91:	c3                   	ret    

0804ac92 <remove>:
 804ac92:	55                   	push   %ebp
 804ac93:	89 e5                	mov    %esp,%ebp
 804ac95:	83 ec 10             	sub    $0x10,%esp
 804ac98:	ff 75 08             	push   0x8(%ebp)
 804ac9b:	6a 05                	push   $0x5
 804ac9d:	cd 30                	int    $0x30
 804ac9f:	83 c4 08             	add    $0x8,%esp
 804aca2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804aca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804aca8:	85 c0                	test   %eax,%eax
 804acaa:	0f 95 c0             	setne  %al
 804acad:	89 ec                	mov    %ebp,%esp
 804acaf:	5d                   	pop    %ebp
 804acb0:	c3                   	ret    

0804acb1 <open>:
 804acb1:	55                   	push   %ebp
 804acb2:	89 e5                	mov    %esp,%ebp
 804acb4:	83 ec 10             	sub    $0x10,%esp
 804acb7:	ff 75 08             	push   0x8(%ebp)
 804acba:	6a 06                	push   $0x6
 804acbc:	cd 30                	int    $0x30
 804acbe:	83 c4 08             	add    $0x8,%esp
 804acc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804acc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804acc7:	89 ec                	mov    %ebp,%esp
 804acc9:	5d                   	pop    %ebp
 804acca:	c3                   	ret    

0804accb <filesize>:
 804accb:	55                   	push   %ebp
 804accc:	89 e5                	mov    %esp,%ebp
 804acce:	83 ec 10             	sub    $0x10,%esp
 804acd1:	ff 75 08             	push   0x8(%ebp)
 804acd4:	6a 07                	push   $0x7
 804acd6:	cd 30                	int    $0x30
 804acd8:	83 c4 08             	add    $0x8,%esp
 804acdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804acde:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ace1:	89 ec                	mov    %ebp,%esp
 804ace3:	5d                   	pop    %ebp
 804ace4:	c3                   	ret    

0804ace5 <read>:
 804ace5:	55                   	push   %ebp
 804ace6:	89 e5                	mov    %esp,%ebp
 804ace8:	83 ec 10             	sub    $0x10,%esp
 804aceb:	8b 45 08             	mov    0x8(%ebp),%eax
 804acee:	8b 55 0c             	mov    0xc(%ebp),%edx
 804acf1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 804acf4:	51                   	push   %ecx
 804acf5:	52                   	push   %edx
 804acf6:	50                   	push   %eax
 804acf7:	6a 08                	push   $0x8
 804acf9:	cd 30                	int    $0x30
 804acfb:	83 c4 10             	add    $0x10,%esp
 804acfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ad01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ad04:	89 ec                	mov    %ebp,%esp
 804ad06:	5d                   	pop    %ebp
 804ad07:	c3                   	ret    

0804ad08 <write>:
 804ad08:	55                   	push   %ebp
 804ad09:	89 e5                	mov    %esp,%ebp
 804ad0b:	83 ec 10             	sub    $0x10,%esp
 804ad0e:	8b 45 08             	mov    0x8(%ebp),%eax
 804ad11:	8b 55 0c             	mov    0xc(%ebp),%edx
 804ad14:	8b 4d 10             	mov    0x10(%ebp),%ecx
 804ad17:	51                   	push   %ecx
 804ad18:	52                   	push   %edx
 804ad19:	50                   	push   %eax
 804ad1a:	6a 09                	push   $0x9
 804ad1c:	cd 30                	int    $0x30
 804ad1e:	83 c4 10             	add    $0x10,%esp
 804ad21:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ad24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ad27:	89 ec                	mov    %ebp,%esp
 804ad29:	5d                   	pop    %ebp
 804ad2a:	c3                   	ret    

0804ad2b <seek>:
 804ad2b:	55                   	push   %ebp
 804ad2c:	89 e5                	mov    %esp,%ebp
 804ad2e:	83 ec 10             	sub    $0x10,%esp
 804ad31:	8b 45 08             	mov    0x8(%ebp),%eax
 804ad34:	8b 55 0c             	mov    0xc(%ebp),%edx
 804ad37:	52                   	push   %edx
 804ad38:	50                   	push   %eax
 804ad39:	6a 0a                	push   $0xa
 804ad3b:	cd 30                	int    $0x30
 804ad3d:	83 c4 0c             	add    $0xc,%esp
 804ad40:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ad43:	90                   	nop
 804ad44:	89 ec                	mov    %ebp,%esp
 804ad46:	5d                   	pop    %ebp
 804ad47:	c3                   	ret    

0804ad48 <tell>:
 804ad48:	55                   	push   %ebp
 804ad49:	89 e5                	mov    %esp,%ebp
 804ad4b:	83 ec 10             	sub    $0x10,%esp
 804ad4e:	ff 75 08             	push   0x8(%ebp)
 804ad51:	6a 0b                	push   $0xb
 804ad53:	cd 30                	int    $0x30
 804ad55:	83 c4 08             	add    $0x8,%esp
 804ad58:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ad5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ad5e:	89 ec                	mov    %ebp,%esp
 804ad60:	5d                   	pop    %ebp
 804ad61:	c3                   	ret    

0804ad62 <close>:
 804ad62:	55                   	push   %ebp
 804ad63:	89 e5                	mov    %esp,%ebp
 804ad65:	83 ec 10             	sub    $0x10,%esp
 804ad68:	ff 75 08             	push   0x8(%ebp)
 804ad6b:	6a 0c                	push   $0xc
 804ad6d:	cd 30                	int    $0x30
 804ad6f:	83 c4 08             	add    $0x8,%esp
 804ad72:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ad75:	90                   	nop
 804ad76:	89 ec                	mov    %ebp,%esp
 804ad78:	5d                   	pop    %ebp
 804ad79:	c3                   	ret    

0804ad7a <mmap>:
 804ad7a:	55                   	push   %ebp
 804ad7b:	89 e5                	mov    %esp,%ebp
 804ad7d:	83 ec 10             	sub    $0x10,%esp
 804ad80:	8b 45 08             	mov    0x8(%ebp),%eax
 804ad83:	8b 55 0c             	mov    0xc(%ebp),%edx
 804ad86:	52                   	push   %edx
 804ad87:	50                   	push   %eax
 804ad88:	6a 19                	push   $0x19
 804ad8a:	cd 30                	int    $0x30
 804ad8c:	83 c4 0c             	add    $0xc,%esp
 804ad8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ad92:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ad95:	89 ec                	mov    %ebp,%esp
 804ad97:	5d                   	pop    %ebp
 804ad98:	c3                   	ret    

0804ad99 <munmap>:
 804ad99:	55                   	push   %ebp
 804ad9a:	89 e5                	mov    %esp,%ebp
 804ad9c:	83 ec 10             	sub    $0x10,%esp
 804ad9f:	ff 75 08             	push   0x8(%ebp)
 804ada2:	6a 1a                	push   $0x1a
 804ada4:	cd 30                	int    $0x30
 804ada6:	83 c4 08             	add    $0x8,%esp
 804ada9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804adac:	90                   	nop
 804adad:	89 ec                	mov    %ebp,%esp
 804adaf:	5d                   	pop    %ebp
 804adb0:	c3                   	ret    

0804adb1 <chdir>:
 804adb1:	55                   	push   %ebp
 804adb2:	89 e5                	mov    %esp,%ebp
 804adb4:	83 ec 10             	sub    $0x10,%esp
 804adb7:	ff 75 08             	push   0x8(%ebp)
 804adba:	6a 1b                	push   $0x1b
 804adbc:	cd 30                	int    $0x30
 804adbe:	83 c4 08             	add    $0x8,%esp
 804adc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804adc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804adc7:	85 c0                	test   %eax,%eax
 804adc9:	0f 95 c0             	setne  %al
 804adcc:	89 ec                	mov    %ebp,%esp
 804adce:	5d                   	pop    %ebp
 804adcf:	c3                   	ret    

0804add0 <mkdir>:
 804add0:	55                   	push   %ebp
 804add1:	89 e5                	mov    %esp,%ebp
 804add3:	83 ec 10             	sub    $0x10,%esp
 804add6:	ff 75 08             	push   0x8(%ebp)
 804add9:	6a 1c                	push   $0x1c
 804addb:	cd 30                	int    $0x30
 804addd:	83 c4 08             	add    $0x8,%esp
 804ade0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ade3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ade6:	85 c0                	test   %eax,%eax
 804ade8:	0f 95 c0             	setne  %al
 804adeb:	89 ec                	mov    %ebp,%esp
 804aded:	5d                   	pop    %ebp
 804adee:	c3                   	ret    

0804adef <readdir>:
 804adef:	55                   	push   %ebp
 804adf0:	89 e5                	mov    %esp,%ebp
 804adf2:	83 ec 10             	sub    $0x10,%esp
 804adf5:	8b 45 08             	mov    0x8(%ebp),%eax
 804adf8:	8b 55 0c             	mov    0xc(%ebp),%edx
 804adfb:	52                   	push   %edx
 804adfc:	50                   	push   %eax
 804adfd:	6a 1d                	push   $0x1d
 804adff:	cd 30                	int    $0x30
 804ae01:	83 c4 0c             	add    $0xc,%esp
 804ae04:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ae07:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ae0a:	85 c0                	test   %eax,%eax
 804ae0c:	0f 95 c0             	setne  %al
 804ae0f:	89 ec                	mov    %ebp,%esp
 804ae11:	5d                   	pop    %ebp
 804ae12:	c3                   	ret    

0804ae13 <isdir>:
 804ae13:	55                   	push   %ebp
 804ae14:	89 e5                	mov    %esp,%ebp
 804ae16:	83 ec 10             	sub    $0x10,%esp
 804ae19:	ff 75 08             	push   0x8(%ebp)
 804ae1c:	6a 1e                	push   $0x1e
 804ae1e:	cd 30                	int    $0x30
 804ae20:	83 c4 08             	add    $0x8,%esp
 804ae23:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ae26:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ae29:	85 c0                	test   %eax,%eax
 804ae2b:	0f 95 c0             	setne  %al
 804ae2e:	89 ec                	mov    %ebp,%esp
 804ae30:	5d                   	pop    %ebp
 804ae31:	c3                   	ret    

0804ae32 <inumber>:
 804ae32:	55                   	push   %ebp
 804ae33:	89 e5                	mov    %esp,%ebp
 804ae35:	83 ec 10             	sub    $0x10,%esp
 804ae38:	ff 75 08             	push   0x8(%ebp)
 804ae3b:	6a 1f                	push   $0x1f
 804ae3d:	cd 30                	int    $0x30
 804ae3f:	83 c4 08             	add    $0x8,%esp
 804ae42:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ae45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ae48:	89 ec                	mov    %ebp,%esp
 804ae4a:	5d                   	pop    %ebp
 804ae4b:	c3                   	ret    

0804ae4c <compute_e>:
 804ae4c:	55                   	push   %ebp
 804ae4d:	89 e5                	mov    %esp,%ebp
 804ae4f:	83 ec 10             	sub    $0x10,%esp
 804ae52:	ff 75 08             	push   0x8(%ebp)
 804ae55:	6a 0e                	push   $0xe
 804ae57:	cd 30                	int    $0x30
 804ae59:	83 c4 08             	add    $0x8,%esp
 804ae5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ae5f:	d9 45 fc             	flds   -0x4(%ebp)
 804ae62:	89 ec                	mov    %ebp,%esp
 804ae64:	5d                   	pop    %ebp
 804ae65:	c3                   	ret    

0804ae66 <sys_pthread_create>:
 804ae66:	55                   	push   %ebp
 804ae67:	89 e5                	mov    %esp,%ebp
 804ae69:	83 ec 10             	sub    $0x10,%esp
 804ae6c:	8b 45 08             	mov    0x8(%ebp),%eax
 804ae6f:	8b 55 0c             	mov    0xc(%ebp),%edx
 804ae72:	8b 4d 10             	mov    0x10(%ebp),%ecx
 804ae75:	51                   	push   %ecx
 804ae76:	52                   	push   %edx
 804ae77:	50                   	push   %eax
 804ae78:	6a 0f                	push   $0xf
 804ae7a:	cd 30                	int    $0x30
 804ae7c:	83 c4 10             	add    $0x10,%esp
 804ae7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804ae82:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804ae85:	89 ec                	mov    %ebp,%esp
 804ae87:	5d                   	pop    %ebp
 804ae88:	c3                   	ret    

0804ae89 <sys_pthread_exit>:
 804ae89:	55                   	push   %ebp
 804ae8a:	89 e5                	mov    %esp,%ebp
 804ae8c:	83 ec 28             	sub    $0x28,%esp
 804ae8f:	6a 10                	push   $0x10
 804ae91:	cd 30                	int    $0x30
 804ae93:	83 c4 04             	add    $0x4,%esp
 804ae96:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804ae99:	c7 44 24 0c dc b8 04 	movl   $0x804b8dc,0xc(%esp)
 804aea0:	08 
 804aea1:	c7 44 24 08 28 b9 04 	movl   $0x804b928,0x8(%esp)
 804aea8:	08 
 804aea9:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
 804aeb0:	00 
 804aeb1:	c7 04 24 fe b8 04 08 	movl   $0x804b8fe,(%esp)
 804aeb8:	e8 9c fc ff ff       	call   804ab59 <debug_panic>

0804aebd <sys_pthread_join>:
 804aebd:	55                   	push   %ebp
 804aebe:	89 e5                	mov    %esp,%ebp
 804aec0:	83 ec 10             	sub    $0x10,%esp
 804aec3:	ff 75 08             	push   0x8(%ebp)
 804aec6:	6a 11                	push   $0x11
 804aec8:	cd 30                	int    $0x30
 804aeca:	83 c4 08             	add    $0x8,%esp
 804aecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804aed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804aed3:	89 ec                	mov    %ebp,%esp
 804aed5:	5d                   	pop    %ebp
 804aed6:	c3                   	ret    

0804aed7 <lock_init>:
 804aed7:	55                   	push   %ebp
 804aed8:	89 e5                	mov    %esp,%ebp
 804aeda:	83 ec 10             	sub    $0x10,%esp
 804aedd:	ff 75 08             	push   0x8(%ebp)
 804aee0:	6a 12                	push   $0x12
 804aee2:	cd 30                	int    $0x30
 804aee4:	83 c4 08             	add    $0x8,%esp
 804aee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804aeea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804aeed:	85 c0                	test   %eax,%eax
 804aeef:	0f 95 c0             	setne  %al
 804aef2:	89 ec                	mov    %ebp,%esp
 804aef4:	5d                   	pop    %ebp
 804aef5:	c3                   	ret    

0804aef6 <lock_acquire>:
 804aef6:	55                   	push   %ebp
 804aef7:	89 e5                	mov    %esp,%ebp
 804aef9:	83 ec 28             	sub    $0x28,%esp
 804aefc:	ff 75 08             	push   0x8(%ebp)
 804aeff:	6a 13                	push   $0x13
 804af01:	cd 30                	int    $0x30
 804af03:	83 c4 08             	add    $0x8,%esp
 804af06:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804af09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804af0c:	85 c0                	test   %eax,%eax
 804af0e:	0f 95 c0             	setne  %al
 804af11:	88 45 f3             	mov    %al,-0xd(%ebp)
 804af14:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 804af18:	34 01                	xor    $0x1,%al
 804af1a:	84 c0                	test   %al,%al
 804af1c:	74 0c                	je     804af2a <lock_acquire+0x34>
 804af1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804af25:	e8 d9 fc ff ff       	call   804ac03 <exit>
 804af2a:	90                   	nop
 804af2b:	89 ec                	mov    %ebp,%esp
 804af2d:	5d                   	pop    %ebp
 804af2e:	c3                   	ret    

0804af2f <lock_release>:
 804af2f:	55                   	push   %ebp
 804af30:	89 e5                	mov    %esp,%ebp
 804af32:	83 ec 28             	sub    $0x28,%esp
 804af35:	ff 75 08             	push   0x8(%ebp)
 804af38:	6a 14                	push   $0x14
 804af3a:	cd 30                	int    $0x30
 804af3c:	83 c4 08             	add    $0x8,%esp
 804af3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804af42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804af45:	85 c0                	test   %eax,%eax
 804af47:	0f 95 c0             	setne  %al
 804af4a:	88 45 f3             	mov    %al,-0xd(%ebp)
 804af4d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 804af51:	34 01                	xor    $0x1,%al
 804af53:	84 c0                	test   %al,%al
 804af55:	74 0c                	je     804af63 <lock_release+0x34>
 804af57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804af5e:	e8 a0 fc ff ff       	call   804ac03 <exit>
 804af63:	90                   	nop
 804af64:	89 ec                	mov    %ebp,%esp
 804af66:	5d                   	pop    %ebp
 804af67:	c3                   	ret    

0804af68 <sema_init>:
 804af68:	55                   	push   %ebp
 804af69:	89 e5                	mov    %esp,%ebp
 804af6b:	83 ec 10             	sub    $0x10,%esp
 804af6e:	8b 45 08             	mov    0x8(%ebp),%eax
 804af71:	8b 55 0c             	mov    0xc(%ebp),%edx
 804af74:	52                   	push   %edx
 804af75:	50                   	push   %eax
 804af76:	6a 15                	push   $0x15
 804af78:	cd 30                	int    $0x30
 804af7a:	83 c4 0c             	add    $0xc,%esp
 804af7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804af80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804af83:	85 c0                	test   %eax,%eax
 804af85:	0f 95 c0             	setne  %al
 804af88:	89 ec                	mov    %ebp,%esp
 804af8a:	5d                   	pop    %ebp
 804af8b:	c3                   	ret    

0804af8c <sema_down>:
 804af8c:	55                   	push   %ebp
 804af8d:	89 e5                	mov    %esp,%ebp
 804af8f:	83 ec 28             	sub    $0x28,%esp
 804af92:	ff 75 08             	push   0x8(%ebp)
 804af95:	6a 16                	push   $0x16
 804af97:	cd 30                	int    $0x30
 804af99:	83 c4 08             	add    $0x8,%esp
 804af9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804af9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804afa2:	85 c0                	test   %eax,%eax
 804afa4:	0f 95 c0             	setne  %al
 804afa7:	88 45 f3             	mov    %al,-0xd(%ebp)
 804afaa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 804afae:	34 01                	xor    $0x1,%al
 804afb0:	84 c0                	test   %al,%al
 804afb2:	74 0c                	je     804afc0 <sema_down+0x34>
 804afb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804afbb:	e8 43 fc ff ff       	call   804ac03 <exit>
 804afc0:	90                   	nop
 804afc1:	89 ec                	mov    %ebp,%esp
 804afc3:	5d                   	pop    %ebp
 804afc4:	c3                   	ret    

0804afc5 <sema_up>:
 804afc5:	55                   	push   %ebp
 804afc6:	89 e5                	mov    %esp,%ebp
 804afc8:	83 ec 28             	sub    $0x28,%esp
 804afcb:	ff 75 08             	push   0x8(%ebp)
 804afce:	6a 17                	push   $0x17
 804afd0:	cd 30                	int    $0x30
 804afd2:	83 c4 08             	add    $0x8,%esp
 804afd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804afd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804afdb:	85 c0                	test   %eax,%eax
 804afdd:	0f 95 c0             	setne  %al
 804afe0:	88 45 f3             	mov    %al,-0xd(%ebp)
 804afe3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 804afe7:	34 01                	xor    $0x1,%al
 804afe9:	84 c0                	test   %al,%al
 804afeb:	74 0c                	je     804aff9 <sema_up+0x34>
 804afed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804aff4:	e8 0a fc ff ff       	call   804ac03 <exit>
 804aff9:	90                   	nop
 804affa:	89 ec                	mov    %ebp,%esp
 804affc:	5d                   	pop    %ebp
 804affd:	c3                   	ret    

0804affe <get_tid>:
 804affe:	55                   	push   %ebp
 804afff:	89 e5                	mov    %esp,%ebp
 804b001:	83 ec 10             	sub    $0x10,%esp
 804b004:	6a 18                	push   $0x18
 804b006:	cd 30                	int    $0x30
 804b008:	83 c4 04             	add    $0x4,%esp
 804b00b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804b00e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804b011:	89 ec                	mov    %ebp,%esp
 804b013:	5d                   	pop    %ebp
 804b014:	c3                   	ret    

0804b015 <pthread_create>:
 804b015:	55                   	push   %ebp
 804b016:	89 e5                	mov    %esp,%ebp
 804b018:	83 ec 18             	sub    $0x18,%esp
 804b01b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804b01e:	89 44 24 08          	mov    %eax,0x8(%esp)
 804b022:	8b 45 08             	mov    0x8(%ebp),%eax
 804b025:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b029:	c7 04 24 5f b0 04 08 	movl   $0x804b05f,(%esp)
 804b030:	e8 31 fe ff ff       	call   804ae66 <sys_pthread_create>
 804b035:	89 ec                	mov    %ebp,%esp
 804b037:	5d                   	pop    %ebp
 804b038:	c3                   	ret    

0804b039 <pthread_exit>:
 804b039:	55                   	push   %ebp
 804b03a:	89 e5                	mov    %esp,%ebp
 804b03c:	83 ec 08             	sub    $0x8,%esp
 804b03f:	e8 45 fe ff ff       	call   804ae89 <sys_pthread_exit>

0804b044 <pthread_join>:
 804b044:	55                   	push   %ebp
 804b045:	89 e5                	mov    %esp,%ebp
 804b047:	83 ec 18             	sub    $0x18,%esp
 804b04a:	8b 45 08             	mov    0x8(%ebp),%eax
 804b04d:	89 04 24             	mov    %eax,(%esp)
 804b050:	e8 68 fe ff ff       	call   804aebd <sys_pthread_join>
 804b055:	83 f8 ff             	cmp    $0xffffffff,%eax
 804b058:	0f 95 c0             	setne  %al
 804b05b:	89 ec                	mov    %ebp,%esp
 804b05d:	5d                   	pop    %ebp
 804b05e:	c3                   	ret    

0804b05f <_pthread_start_stub>:
 804b05f:	55                   	push   %ebp
 804b060:	89 e5                	mov    %esp,%ebp
 804b062:	83 ec 18             	sub    $0x18,%esp
 804b065:	8b 45 0c             	mov    0xc(%ebp),%eax
 804b068:	89 04 24             	mov    %eax,(%esp)
 804b06b:	8b 45 08             	mov    0x8(%ebp),%eax
 804b06e:	ff d0                	call   *%eax
 804b070:	e8 c4 ff ff ff       	call   804b039 <pthread_exit>

0804b075 <vprintf>:
 804b075:	55                   	push   %ebp
 804b076:	89 e5                	mov    %esp,%ebp
 804b078:	83 ec 18             	sub    $0x18,%esp
 804b07b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804b07e:	89 44 24 08          	mov    %eax,0x8(%esp)
 804b082:	8b 45 08             	mov    0x8(%ebp),%eax
 804b085:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b089:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804b090:	e8 9e 00 00 00       	call   804b133 <vhprintf>
 804b095:	89 ec                	mov    %ebp,%esp
 804b097:	5d                   	pop    %ebp
 804b098:	c3                   	ret    

0804b099 <hprintf>:
 804b099:	55                   	push   %ebp
 804b09a:	89 e5                	mov    %esp,%ebp
 804b09c:	83 ec 28             	sub    $0x28,%esp
 804b09f:	8d 45 10             	lea    0x10(%ebp),%eax
 804b0a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804b0a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804b0a8:	89 44 24 08          	mov    %eax,0x8(%esp)
 804b0ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 804b0af:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b0b3:	8b 45 08             	mov    0x8(%ebp),%eax
 804b0b6:	89 04 24             	mov    %eax,(%esp)
 804b0b9:	e8 75 00 00 00       	call   804b133 <vhprintf>
 804b0be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804b0c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b0c4:	89 ec                	mov    %ebp,%esp
 804b0c6:	5d                   	pop    %ebp
 804b0c7:	c3                   	ret    

0804b0c8 <puts>:
 804b0c8:	55                   	push   %ebp
 804b0c9:	89 e5                	mov    %esp,%ebp
 804b0cb:	83 ec 18             	sub    $0x18,%esp
 804b0ce:	8b 45 08             	mov    0x8(%ebp),%eax
 804b0d1:	89 04 24             	mov    %eax,(%esp)
 804b0d4:	e8 71 f3 ff ff       	call   804a44a <strlen>
 804b0d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 804b0dd:	8b 45 08             	mov    0x8(%ebp),%eax
 804b0e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b0e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804b0eb:	e8 18 fc ff ff       	call   804ad08 <write>
 804b0f0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 804b0f7:	e8 09 00 00 00       	call   804b105 <putchar>
 804b0fc:	b8 00 00 00 00       	mov    $0x0,%eax
 804b101:	89 ec                	mov    %ebp,%esp
 804b103:	5d                   	pop    %ebp
 804b104:	c3                   	ret    

0804b105 <putchar>:
 804b105:	55                   	push   %ebp
 804b106:	89 e5                	mov    %esp,%ebp
 804b108:	83 ec 28             	sub    $0x28,%esp
 804b10b:	8b 45 08             	mov    0x8(%ebp),%eax
 804b10e:	88 45 f7             	mov    %al,-0x9(%ebp)
 804b111:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 804b118:	00 
 804b119:	8d 45 f7             	lea    -0x9(%ebp),%eax
 804b11c:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b120:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804b127:	e8 dc fb ff ff       	call   804ad08 <write>
 804b12c:	8b 45 08             	mov    0x8(%ebp),%eax
 804b12f:	89 ec                	mov    %ebp,%esp
 804b131:	5d                   	pop    %ebp
 804b132:	c3                   	ret    

0804b133 <vhprintf>:
 804b133:	55                   	push   %ebp
 804b134:	89 e5                	mov    %esp,%ebp
 804b136:	83 ec 68             	sub    $0x68,%esp
 804b139:	8d 45 ac             	lea    -0x54(%ebp),%eax
 804b13c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804b13f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804b146:	8b 45 08             	mov    0x8(%ebp),%eax
 804b149:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804b14c:	8d 45 ac             	lea    -0x54(%ebp),%eax
 804b14f:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804b153:	c7 44 24 08 7f b1 04 	movl   $0x804b17f,0x8(%esp)
 804b15a:	08 
 804b15b:	8b 45 10             	mov    0x10(%ebp),%eax
 804b15e:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b162:	8b 45 0c             	mov    0xc(%ebp),%eax
 804b165:	89 04 24             	mov    %eax,(%esp)
 804b168:	e8 b9 da ff ff       	call   8048c26 <__vprintf>
 804b16d:	8d 45 ac             	lea    -0x54(%ebp),%eax
 804b170:	89 04 24             	mov    %eax,(%esp)
 804b173:	e8 5d 00 00 00       	call   804b1d5 <flush>
 804b178:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804b17b:	89 ec                	mov    %ebp,%esp
 804b17d:	5d                   	pop    %ebp
 804b17e:	c3                   	ret    

0804b17f <add_char>:
 804b17f:	55                   	push   %ebp
 804b180:	89 e5                	mov    %esp,%ebp
 804b182:	83 ec 38             	sub    $0x38,%esp
 804b185:	8b 45 08             	mov    0x8(%ebp),%eax
 804b188:	88 45 e4             	mov    %al,-0x1c(%ebp)
 804b18b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804b18e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804b191:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b194:	8b 40 40             	mov    0x40(%eax),%eax
 804b197:	8d 48 01             	lea    0x1(%eax),%ecx
 804b19a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804b19d:	89 4a 40             	mov    %ecx,0x40(%edx)
 804b1a0:	0f b6 55 e4          	movzbl -0x1c(%ebp),%edx
 804b1a4:	88 10                	mov    %dl,(%eax)
 804b1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b1a9:	8b 40 40             	mov    0x40(%eax),%eax
 804b1ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804b1af:	83 c2 40             	add    $0x40,%edx
 804b1b2:	39 d0                	cmp    %edx,%eax
 804b1b4:	72 0b                	jb     804b1c1 <add_char+0x42>
 804b1b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b1b9:	89 04 24             	mov    %eax,(%esp)
 804b1bc:	e8 14 00 00 00       	call   804b1d5 <flush>
 804b1c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b1c4:	8b 40 44             	mov    0x44(%eax),%eax
 804b1c7:	8d 50 01             	lea    0x1(%eax),%edx
 804b1ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b1cd:	89 50 44             	mov    %edx,0x44(%eax)
 804b1d0:	90                   	nop
 804b1d1:	89 ec                	mov    %ebp,%esp
 804b1d3:	5d                   	pop    %ebp
 804b1d4:	c3                   	ret    

0804b1d5 <flush>:
 804b1d5:	55                   	push   %ebp
 804b1d6:	89 e5                	mov    %esp,%ebp
 804b1d8:	83 ec 18             	sub    $0x18,%esp
 804b1db:	8b 45 08             	mov    0x8(%ebp),%eax
 804b1de:	8b 50 40             	mov    0x40(%eax),%edx
 804b1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 804b1e4:	39 c2                	cmp    %eax,%edx
 804b1e6:	76 26                	jbe    804b20e <flush+0x39>
 804b1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 804b1eb:	8b 40 40             	mov    0x40(%eax),%eax
 804b1ee:	8b 55 08             	mov    0x8(%ebp),%edx
 804b1f1:	29 d0                	sub    %edx,%eax
 804b1f3:	89 c1                	mov    %eax,%ecx
 804b1f5:	8b 55 08             	mov    0x8(%ebp),%edx
 804b1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 804b1fb:	8b 40 48             	mov    0x48(%eax),%eax
 804b1fe:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 804b202:	89 54 24 04          	mov    %edx,0x4(%esp)
 804b206:	89 04 24             	mov    %eax,(%esp)
 804b209:	e8 fa fa ff ff       	call   804ad08 <write>
 804b20e:	8b 55 08             	mov    0x8(%ebp),%edx
 804b211:	8b 45 08             	mov    0x8(%ebp),%eax
 804b214:	89 50 40             	mov    %edx,0x40(%eax)
 804b217:	90                   	nop
 804b218:	89 ec                	mov    %ebp,%esp
 804b21a:	5d                   	pop    %ebp
 804b21b:	c3                   	ret    

0804b21c <debug_backtrace>:
 804b21c:	55                   	push   %ebp
 804b21d:	89 e5                	mov    %esp,%ebp
 804b21f:	83 ec 28             	sub    $0x28,%esp
 804b222:	8b 45 04             	mov    0x4(%ebp),%eax
 804b225:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b229:	c7 04 24 3c b9 04 08 	movl   $0x804b93c,(%esp)
 804b230:	e8 c9 d9 ff ff       	call   8048bfe <printf>
 804b235:	8b 45 00             	mov    0x0(%ebp),%eax
 804b238:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804b23b:	eb 20                	jmp    804b25d <debug_backtrace+0x41>
 804b23d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b240:	83 c0 04             	add    $0x4,%eax
 804b243:	8b 00                	mov    (%eax),%eax
 804b245:	89 44 24 04          	mov    %eax,0x4(%esp)
 804b249:	c7 04 24 4b b9 04 08 	movl   $0x804b94b,(%esp)
 804b250:	e8 a9 d9 ff ff       	call   8048bfe <printf>
 804b255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b258:	8b 00                	mov    (%eax),%eax
 804b25a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804b25d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b260:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 804b265:	76 09                	jbe    804b270 <debug_backtrace+0x54>
 804b267:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804b26a:	8b 00                	mov    (%eax),%eax
 804b26c:	85 c0                	test   %eax,%eax
 804b26e:	75 cd                	jne    804b23d <debug_backtrace+0x21>
 804b270:	c7 04 24 4f b9 04 08 	movl   $0x804b94f,(%esp)
 804b277:	e8 4c fe ff ff       	call   804b0c8 <puts>
 804b27c:	0f b6 05 43 cf 04 08 	movzbl 0x804cf43,%eax
 804b283:	34 01                	xor    $0x1,%al
 804b285:	84 c0                	test   %al,%al
 804b287:	74 13                	je     804b29c <debug_backtrace+0x80>
 804b289:	c6 05 43 cf 04 08 01 	movb   $0x1,0x804cf43
 804b290:	c7 04 24 54 b9 04 08 	movl   $0x804b954,(%esp)
 804b297:	e8 2c fe ff ff       	call   804b0c8 <puts>
 804b29c:	90                   	nop
 804b29d:	89 ec                	mov    %ebp,%esp
 804b29f:	5d                   	pop    %ebp
 804b2a0:	c3                   	ret    
