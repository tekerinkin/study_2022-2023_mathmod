---
## Front matter
title: "Отчет по лабораторной работе №8"
subtitle: "Модель конкуренции двух фирм"
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

Реализовать на языках программирования Julia и Openmodelica модель конкуренции двух фирм. Улучшить навыки использования пакета DifferentialEquations.

# Задание

**Случай 1**. Рассмотрим две фирмы, производящие взаимозаменяемые товары одинакового качества и находящиеся в одной рыночной нише. Считаем, что в рамках нашей модели конкурентная борьба ведётся только рыночными методами. То есть, конкуренты могут влиять на противника путем изменения параметров своего
производства: себестоимость, время цикла, но не могут прямо вмешиваться в ситуацию на рынке («назначать» цену или влиять на потребителей каким-либо иным способом.) Будем считать, что постоянные издержки пренебрежимо малы, и в модели учитывать не будем. В этом случае динамика изменения объемов продаж фирмы 1 и фирмы 2 описывается следующей системой уравнений:

$$ \frac{dM_{1}}{d\theta} = M_{1} - \frac{b}{c_{1}}M_{1}M_{2} - \frac{a_{1}}{c_{1}}M^{2}_{1} $$

$$ \frac{dM_{2}}{d\theta} = \frac{c_{1}}{c_{2}}M_{2} - \frac{b}{c_{1}}M_{1}M_{2} - \frac{a_{2}}{c_{1}}M^{2}_{2} $$

**Случай 2**. Рассмотрим модель, когда, помимо экономического фактора влияния (изменение себестоимости, производственного цикла, использование кредита и т.п.), используются еще и социально-психологические факторы – формирование общественного предпочтения одного товара другому, не зависимо от их качества и цены. В этом случае взаимодействие двух фирм будет зависеть друг от друга, соответственно коэффициент перед M1M2 будет отличаться. Пусть в
рамках рассматриваемой модели динамика изменения объемов продаж фирмы 1 и фирмы 2 описывается следующей системой уравнений:

$$ \frac{dM_{1}}{d\theta} = M_{1} - (\frac{b}{c_{1}} + 0,0007)M_{1}M_{2} - \frac{a_{1}}{c_{1}}M^{2}_{1} $$

$$ \frac{dM_{2}}{d\theta} = \frac{c_{1}}{c_{2}}M_{2} - \frac{b}{c_{1}}M_{1}M_{2} - \frac{a_{2}}{c_{1}}M^{2}_{2} $$

Для обоих случаев рассмотрим задачу со следующими начальными условиями и параметрами @Lab:
$$ M^{1}_{0} = 4.4, M^{2}_{0} = 4$$
$$ p_{cr} = 10.5, N = 28, q = 1$$
$$ \tau_{1} = 16, \tau_{2} = 25$$
$$ p_{1} = 7.2, p_{2} = 5.1$$

# Теоретическое введение

Случай 1
Рассмотрим две фирмы, производящие взаимозаменяемые товары одинакового качества и находящиеся в одной рыночной нише. Последнее означает, что у потребителей в этой нише нет априорных предпочтений, и они приобретут тот или иной товар, не обращая внимания на знак фирмы.
В этом случае, на рынке устанавливается единая цена, которая определяется балансом суммарного предложения и спроса. Иными словами, в рамках нашей модели конкурентная борьба ведётся только рыночными методами. То есть, конкуренты могут влиять на противника путем изменения параметров своего производства: себестоимость, время цикла, но не могут прямо вмешиваться в ситуацию на рынке («назначать» цену или влиять на потребителей каким- либо иным способом.)
Уравнения динамики оборотных средств запишем  в виде:
$$ \frac{dM_{1}}{dt} = -\frac{M_{1}}{\tau_{1}} + N_{1}q(1 - \frac{p}{p_{cr}})p - \kappa_{1} $$

$$ \frac{dM_{2}}{dt} = -\frac{M_{2}}{\tau_{2}} + N_{2}q(1 - \frac{p}{p_{cr}})p - \kappa_{2} $$

где
 
 - $M_{i}$ - оборотные средства $i$-го предприятия 
 - $\tau_{i}$ - длительность производственного цикла $i$-го предприятия
 - $p$ - рыночная цены товара
 - $\kappa_{i}$ - постоянные издержки $i$-го предприятия, которые не зависят от количества выпускаемой продукции
 - $p_{cr}$ - критическая стоимость продукта
 - $N_{i}$ - число потребителей, приобретших товар $i$-го предприятия

Учтем, что товарный баланс устанавливается быстро, то есть, произведенный каждой фирмой товар не накапливается, а реализуется по цене $p$. Тогда

$$ \frac{M_{1}}{\tau_{1}\tilde{p}_{1}} = N_{1}q(1 - \frac{p}{p_{cr}}) $$

$$ \frac{M_{2}}{\tau_{2}\tilde{p}_{2}} = N_{2}q(1 - \frac{p}{p_{cr}}) $$

где $\tilde{p}_{1}$ и $\tilde{p}_{2}$ - себестоимости товаров в первой и второй фирме

С учетом предыдущего, перепишем последнее в виде:

$$ \frac{dM_{1}}{dt} = -\frac{M_{1}}{\tau_{1}}(1 - \frac{p}{\tilde{p}_{1}}) - \kappa_{1}$$
$$ \frac{dM_{2}}{dt} = -\frac{M_{2}}{\tau_{2}}(1 - \frac{p}{\tilde{p}_{2}}) - \kappa_{2}$$

Уравнение для цены:

$$ \frac{dp}{dt} = -\gamma(\frac{M_{1}}{\tau_{1}\tilde{p}_{1}} + \frac{M_{2}}{\tau_{2}\tilde{p}_{2}} - Nq(1 - \frac{p}{p_{cr}}))$$

Считая,  что ценовое равновесие устанавливается быстро, получим:

$$ p = p_{cr}(1 - \frac{1}{Nq}(\frac{M_{1}}{\tau_{1}\tilde{p}_{1}} + \frac{M_{2}}{\tau_{2}\tilde{p}_{2}})) $$

Подствавив, имеем @Theory:

$$ \frac{dM_{1}}{dt} = c_{1}M_{1} - bM_{1}M_{2} - a_{1}M^{2}_{1} - \kappa_{1} $$
$$ \frac{dM_{2}}{dt} = c_{2}M_{2} - bM_{1}M_{2} - a_{2}M^{2}_{2} - \kappa_{2} $$

# Выполнение лабораторной работы

1. На первом этапе имплементировали модель, используя язык программирования Julia. Получили следующий код:

```julia
using Plots
using DifferentialEquations

M1 = 4.4
M2 = 4
p_cr = 10.5
N = 28
q = 1
tau1 = 16
tau2 = 25
p1 = 7.2
p2 = 5.1

a1 = p_cr/((tau1^2) * (p1^2) * N *q)
a2 = p_cr/((tau2^2) * (p2^2) * N *q)
b = p_cr/((tau1^2) * (p1^2) * (tau2^2) * (p2^2) * N *q)
c1 = (p_cr-p1)/(tau1 * p1)
c2 = (p_cr - p2)/(tau2 * p2)

function ode_fn_1(du, u, p, t)
    x,y = u 
    du[1] = x - (b/c1)*x*y - (a1/c1)*(x^2)
    du[2] = (c2/c1)*y - (b/c1)*x*y - (a2/c1)*(y^2)
end

init_val = [M1, M2]

t_begin = 0
t_end = 30
tspan = (t_begin, t_end)

prob = ODEProblem(ode_fn_1, init_val, tspan)
sol = solve(prob, Tsit5(), reltol=1e-16, abstol=1e-16)

x_sol = [u[1] for u in sol.u]
y_sol = [u[2] for u in sol.u]

plot(sol.t * c1, x_sol, 
    linewidth = 2,
    title = "Изменение оборотных средств фирм",
    label = "M1",
    legend = true)

plot!(sol.t * c1, y_sol, 
    linewidth = 2,
    title = "Изменение оборотных средств фирм",
    label = "M2",
    legend = true)

function ode_fn_2(du, u, p, t)
    x,y = u 
    du[1] = x - (b/c1 + 0.0007)*x*y - (a1/c1)*(x^2)
    du[2] = (c2/c1)*y - (b/c1)*x*y - (a2/c1)*(y^2)
end

init_val = [M1, M2]

t_begin = 0
t_end = 30
tspan = (t_begin, t_end)

prob1 = ODEProblem(ode_fn_2, init_val, tspan)
sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)

x_sol_1 = [u[1] for u in sol1.u]
y_sol_1 = [u[2] for u in sol1.u]

plot(sol1.t * c1, x_sol_1, 
    linewidth = 2,
    title = "Изменение оборотных средств фирм",
    label = "M1",
    legend = true)

plot!(sol1.t * c1, y_sol_1, 
    linewidth = 2,
    title = "Изменение оборотных средств фирм",
    label = "M2",
    legend = true)
```

В результате работы программы получили следующие результаты

![Графики изменения оборотных средств в первом случае №1(Julia)](image/1(Julia).png){#fig:001 width=70%}

![Графики изменения оборотных средств в первом случае №2(Julia)](image/2(Julia).png){#fig:002 width=70%}


2. На втором этапе смоделировали задачу в среде моделирования Openmodelica. Получили следующий код:

```openmodelica
model Concurrency
  Real m1, m2, t;
initial equation
  t = 0;
  m1 = 4.4;
  m2 = 4;
equation
  der(t) = 1;
  der(m1) = m1 - ((10.5*16*7.2)/((3.3)*16*16*7.2*7.2*25*25*5.1*5.1*28))*m1*m2 - ((10.5*16*7.2)/(3.3*16*16*7.2*7.2*28))*m1*m1;
  der(m2) = ((5.4*16*7.2)/(3.3*25*5.1))*m2 - ((10.5*16*7.2)/((3.3)*16*16*7.2*7.2*25*25*5.1*5.1*28))*m1*m2 - ((10.5*16*7.2)/(3.3*25*25*5.1*5.1*28))*m2*m2;
end Concurrency;
```
```openmodelica
model Concurrency
  Real m1, m2, t;
initial equation
  t = 0;
  m1 = 4.4;
  m2 = 4;
equation
  der(t) = 1;
  der(m1) = m1 - ((10.5*16*7.2)/((3.3)*16*16*7.2*7.2*25*25*5.1*5.1*28) + 0.0007)*m1*m2 - ((10.5*16*7.2)/(3.3*16*16*7.2*7.2*28))*m1*m1;
  der(m2) = ((5.4*16*7.2)/(3.3*25*5.1))*m2 - ((10.5*16*7.2)/((3.3)*16*16*7.2*7.2*25*25*5.1*5.1*28))*m1*m2 - ((10.5*16*7.2)/(3.3*25*25*5.1*5.1*28))*m2*m2;
end Concurrency;
```

В результате работы программы получили следующие результаты

![Графики изменения оборотных средств в первом случае №1(OM)](image/1(OM).png){#fig:004 width=70%}

![Графики изменения оборотных средств в первом случае №2(OM)](image/2(OM).png){#fig:005 width=70%}

# Выводы

Программно реализовали модель для оценки эффективности рекламы на языках программирования Julia и Openmodelica. Получили графическое отображение изменения числа оборотных средств у фирм в случае конкуренции двух фирм. 

# Список литературы{.unnumbered}

::: {#refs}
:::
