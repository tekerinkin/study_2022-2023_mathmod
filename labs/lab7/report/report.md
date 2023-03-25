---
## Front matter
title: "Отчет по лабораторной работе №7"
subtitle: "Эффективность рекалмы"
author: "Дмитрий Сергеевич Шестаков"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
lot: true # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: PT Serif
romanfont: PT Serif
sansfont: PT Sans
monofont: PT Mono
mainfontoptions: Ligatures=TeX
romanfontoptions: Ligatures=TeX
sansfontoptions: Ligatures=TeX,Scale=MatchLowercase
monofontoptions: Scale=MatchLowercase,Scale=0.9
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
  - \usepackage{amsmath}
---

# Цель работы

Реализовать на языках программирования Julia и Openmodelica модель для оценки эффективности рекламы. Улучшить навыки использования пакета DifferentialEquations.

# Задание

29 января в городе открылся новый салон красоты. Полагаем, что на момент
открытия о салоне знали $N_0 = 11$ потенциальных клиентов. По маркетинговым
исследованиям известно, что в районе проживают $N = 1111$ потенциальных клиентов салона. Поэтому после открытия салона руководитель запускает активную рекламную компанию. После этого скорость изменения числа знающих о салоне пропорциональна как числу знающих о нем, так и числу не знаю о нем.

Постройте график распространения рекламы, математическая модель которой описывается следующим уравнением @Lab:

1) $\frac{dn}{dt} = (0.7 + 0.00002*n(t))(N - n(t))$
2) $\frac{dn}{dt} = (0.00008 + 0.9*n(t))(N - n(t))$
3) $\frac{dn}{dt} = (0.9cos(t) + 0.9*n(t)*cos(t))(N - n(t))$

# Теоретическое введение

Организуется рекламная кампания нового товара или услуги. Необходимо, чтобы прибыль будущих продаж с избытком покрывала издержки на рекламу. Вначале расходы могут превышать прибыль, поскольку лишь малая часть потенциальных покупателей будет информирована о новинке. Затем, при увеличении числа продаж, возрастает и прибыль, и, наконец, наступит момент, когда рынок насытиться, и рекламировать товар станет бесполезным.
Предположим, что торговыми учреждениями реализуется некоторая продукция, о которой в момент времени t из числа потенциальных покупателей N знает лишь n покупателей. Для ускорения сбыта продукции запускается реклама по радио, телевидению и других средств массовой информации. После запуска рекламной кампании информация о продукции начнет распространяться среди потенциальных покупателей путем общения друг с другом. Таким образом, после запуска рекламных объявлений скорость изменения числа знающих о продукции людей пропорциональна как числу знающих о товаре покупателей, так и числу покупателей о нем не знающих.

Модель рекламной кампании описывается следующими величинами.
Считаем, что $\frac{dn}{dt}$ - скорость изменения со временем числа потребителей, узнавших о товаре и готовых его купить, $t$ - время, прошедшее с начала рекламной кампании, $n(t)$ - число уже информированныз клиентов. Эта величина пропорциональна числу покупателей, еще не занющих о нем, это описывается следующим образом: $\alpha_{1}(t)(N - n(t))$, где N - общее число потенциальных плетежеспособных покупателей, $\alpha_{1}(t) > 0$ - характеризует интенсивность рекламной кампании. Помимо этого, узнавшие о товаре потребители также распространяют полученную информацию среди потенциальных покупателей, не знающих о нем (в этом случае работает т.н. сарафанное радио). Этот вклад в рекламу описывается величиной $\alpha_{2}(t)n(t)(N - n(t))$, эта величина увеличивается с увеличением потребителей
узнавших о товаре. Математическая модель распространения рекламы описывается уравнением @Theory:
  $$\frac{dn}{dt} = (\alpha_{1}(t) + \alpha_{2}(t)n(t))(N-n(t))$$

# Выполнение лабораторной работы

1. На первом этапе имплементировали модель, используя язык программирования Julia. Получили следующий код:

```julia
N = 1111

ode_fn(r, p, t) = (0.7 + 0.00002*r)*(N - r)

t_begin = 0.0
t_end = 40.0
tspan = (t_begin, t_end)

r0 = 11

prob1 = ODEProblem(ode_fn, r0, tspan)
sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)

plot(sol1.t, sol1, 
    linewidth = 2,
     title = "График распространения рекламы #1",
     color =:red,
     legend = true)
savefig("../report/image/graphic1.png")

ode_fn1(r, p, t) = (0.00008 + 0.9*r)*(N - r)

t_begin = 0.0
t_end = 0.05
tspan = (t_begin, t_end)

prob2 = ODEProblem(ode_fn1, r0, tspan)
sol2 = solve(prob2, Tsit5(), reltol=1e-16, abstol=1e-16)

plot(sol2.t, sol2, 
    linewidth = 2,
     title = "График распространения рекламы #2",
     color =:blue,
     legend = true)
savefig("../report/image/graphic2.png")

ode_fn2(r, p, t) = (0.9*cos(t) + 0.9*r*cos(t))*(N - r)

t_begin = 0.0
t_end = 0.05
tspan = (t_begin, t_end)

prob3 = ODEProblem(ode_fn2, r0, tspan)
sol3 = solve(prob3, Tsit5(), reltol=1e-16, abstol=1e-16)

plot(sol3.t, sol3, 
    linewidth = 2,
     title = "График распространения рекламы #3",
     color =:green,
     legend = true)
savefig("../report/image/graphic3.png")
```

В результате работы программы получили следующие результаты

![Графики распространения рекламы №1(Julia)](image/graphic1.png){#fig:001 width=70%}

![Графики распространения рекламы №2(Juia)](image/graphic2.png){#fig:002 width=70%}

![Графики распространения рекламы №3(Julia)](image/graphic3.png){#fig:003 width=70%}

2. На втором этапе смоделировали задачу в среде моделирования Openmodelica. Получили следующий код:

```openmodelica
model Advertisment
  Real x, t;
initial equation
  x = 11;
equation
  der(t) = 1;
  der(x) = (0.7 + 0.00002*x)*(1111 - x);
end;
```
```openmodelica
model Advertisment
  Real x, t;
initial equation
  x = 11;
equation
  der(t) = 1;
  der(x) = (0.00008 + 0.9*x)*(1111 - x);
end;
```

```openmodelica
model Advertisment
  Real x, t;
initial equation
  x = 11;
equation
  der(t) = 1;
  der(x) = (0.9*cos(t) + 0.9*x*cos(t))*(1111 - x);
end;
```

В результате работы программы получили следующие результаты

![Графики распространения рекламы №1(OM)](image/graphic1(OM).png){#fig:004 width=70%}

![Графики распространения рекламы №2(OM)](image/graphic2(OM).png){#fig:005 width=70%}

![Графики распространения рекламы №3(OM)](image/graphic3(OM).png){#fig:006 width=70%}

# Выводы

Программно реализовали модель для оценки эффективности рекламы на языках программирования Julia и Openmodelica. Получили графическое отображение сокрости роста числа проинформированных человек из целевой аудитории. 

# Список литературы{.unnumbered}

::: {#refs}
:::
