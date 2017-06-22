! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine dylech(nomo, lischa, nbexre, exreco, exresu)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/infniv.h"
#include "asterfort/lischk.h"
#include "asterfort/lisimp.h"
#include "asterfort/lislec.h"
#include "asterfort/lisnbg.h"
#include "asterfort/lisnnb.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=8) :: nomo
    character(len=19) :: lischa
    character(len=24) :: exreco, exresu
    integer :: nbexre
!
! ----------------------------------------------------------------------
!
! DYNA_VIBRA//HARM
!
! LECTURE DES CHARGEMENTS
!
! ----------------------------------------------------------------------
!
!
! IN  NOMO   : NOM DU MODELE
! OUT LISCHA : SD LISTE DES CHARGES
! OUT NBEXRE : NOMBRE DE EXCIT_RESU
! OUT EXRECO : LISTE DES COEFFICIENTS DANS EXCIT_RESU
! OUT EXRESU : LISTE DES RESULTATS DANS EXCIT_RESU
!
! ----------------------------------------------------------------------
!
    character(len=16) :: motfac, nomcmd
    integer :: iresu, jlccre, jlresu, n
    integer :: nbveas, nbveag, nbveat, nbchar
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    motfac = 'EXCIT'
    nomcmd = 'DYNA_VIBRA'
    nbexre = 0
    call infniv(ifm, niv)
!
! --- LECTURE DONNNES CHARGEMENTS
!
    call lislec(motfac, 'MECANIQUE', 'V', lischa)
!
! --- AFFICHAGE DE LA LISTE DES CHARGES
!
    if (niv .ge. 2) call lisimp(lischa, ifm)
!
! --- VERIFICATIONS DE LA LISTE DES CHARGES
!
    call lischk(nomo, 'MECANIQUE', nomcmd, lischa)
!
! --- LECTURE INFORMATIONS EXCIT_RESU
!
    call getfac('EXCIT_RESU', nbexre)
    exreco = '&&DYLECH.COEF_CRE'
    exresu = '&&DYLECH.LISTRESU'
    if (nbexre .ne. 0) then
        call wkvect(exreco, 'V V C  ', nbexre, jlccre)
        call wkvect(exresu, 'V V K8 ', nbexre, jlresu)
        do 252 iresu = 1, nbexre
            call getvid('EXCIT_RESU', 'RESULTAT', iocc=iresu, scal=zk8( jlresu+iresu-1), nbret=n)
            call getvc8('EXCIT_RESU', 'COEF_MULT_C', iocc=iresu, scal=zc (jlccre+iresu-1),&
                        nbret=n)
252      continue
    endif
!
! --- EXCLUSION VECT_ASSE/CHARGE
!
    nbveas = lisnbg(lischa,'VECT_ASSE' )
    nbveag = lisnbg(lischa,'VECT_ASSE_GENE')
    nbveat = nbveas+nbveag
    call lisnnb(lischa, nbchar)
    if (nbveat .ne. 0) then
        if (nbveat .ne. nbchar) then
            call utmess('F', 'CHARGES5_1')
        endif
    endif
!
end subroutine
