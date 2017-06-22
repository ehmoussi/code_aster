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

subroutine imbamo(nomres)
!    P. RICHARD     DATE 21/02/1991
!-----------------------------------------------------------------------
!  BUT:  IMPRIMER LES RESULTATS RELATIFS A LA BASE MODALE
    implicit none
!
!-----------------------------------------------------------------------
!
! NOMRES   /I/: NOM DU CONCEPT RESULTAT
!
!
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
!
!-----------------------------------------------------------------------
    integer :: i, nbdef, nbmod, nbpabm, nbtot
!
    real(kind=8) :: freq, genek, genem
!-----------------------------------------------------------------------
    parameter    (nbpabm=8)
    character(len=8) :: nomres, intf, nomnoe, nomcmp
    character(len=19) :: raid, mass, typeba, valk(4)
    character(len=14) :: numref
    integer :: ldpar(nbpabm), vali(2)
    character(len=16) :: bmpara(nbpabm), typdef
    character(len=8) :: rescyc
    character(len=8) :: k8bid
    real(kind=8) :: valr(3)
!
!-----------------------------------------------------------------------
!
    data  bmpara/&
     &  'NUME_MODE  '     , 'FREQ'       , 'NORME'           ,&
     &  'NOEUD_CMP'       , 'TYPE_DEFO'          , 'OMEGA2'   ,&
     &  'MASS_GENE'      , 'RIGI_GENE'/
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
!----------------DETERMINATION DU TYPE DE LA BASE-----------------------
!
!------------------RECUPERATION DES CONCEPT AMONT-----------------------
!
    call dismoi('REF_RIGI_PREM', nomres, 'RESU_DYNA', repk=raid, arret='C')
    call dismoi('REF_MASS_PREM', nomres, 'RESU_DYNA', repk=mass, arret='C')
    call dismoi('NUME_DDL', nomres, 'RESU_DYNA', repk=numref, arret='C')
    call dismoi('REF_INTD_PREM', nomres, 'RESU_DYNA', repk=intf, arret='C')
    call dismoi('TYPE_BASE', nomres, 'RESU_DYNA', repk=typeba, arret='C')
!
!--------------------------------ECRITURES------------------------------
!
    call utmess('I', 'ALGELINE6_1', sk=nomres)
    call dismoi('NB_MODES_TOT', nomres, 'RESULTAT', repi=nbtot)
!
!    CAS D'UNE BASE DE TYPE CONNUE
!
    if (typeba(1:9) .eq. 'CLASSIQUE') then
!
        call dismoi('NB_MODES_STA', nomres, 'RESULTAT', repi=nbdef)
        call dismoi('NB_MODES_DYN', nomres, 'RESULTAT', repi=nbmod)
!
        valk(1)=intf
        valk(2)=numref
        valk(3)=raid
        valk(4)=mass
        vali(1)=nbmod
        vali(2)=nbdef
        call utmess('I', 'ALGELINE6_2', nk=4, valk=valk, ni=2,&
                    vali=vali)
!
    endif
!
!   CAS D'UNE BASE DE TYPE CYCLIQUE
!
    if (typeba(1:8) .eq. 'CYCLIQUE') then
        call dismoi('NOM_MODE_CYCL', intf, 'INTERF_DYNA', repk=rescyc)
!
        valk(1)=intf
        valk(2)=numref
        call utmess('I', 'ALGELINE6_3', nk=2, valk=valk)
!
    endif
!
! CAS D'UNE BASE DE RITZ
!
    if (typeba(1:4) .eq. 'RITZ') then
!
        valk(1)=numref
        vali(1)=nbtot
        call utmess('I', 'ALGELINE6_4', sk=valk(1), si=vali(1))
!
    endif
!
    call utmess('I', 'ALGELINE6_5')
!
    do i = 1, nbtot
!
        call rsadpa(nomres, 'L', nbpabm, bmpara, i,&
                    0, tjv=ldpar, styp=k8bid, istop=0)
!
        typdef=zk16(ldpar(5))
!
        vali(1)=i
        if (typdef .eq. 'PROPRE') then
!
            freq=zr(ldpar(2))
            genek=zr(ldpar(8))
            genem=zr(ldpar(7))
            valr(1)=freq
            valr(2)=genem
            valr(3)=genek
            call utmess('I', 'ALGELINE6_6', si=vali(1), nr=3, valr=valr)
!
        else
!
            nomnoe=zk16(ldpar(4))(1:8)
            nomcmp=zk16(ldpar(4))(9:16)
            valk(1)=typdef
            valk(2)=nomnoe
            valk(3)=nomcmp
            call utmess('I', 'ALGELINE6_7', nk=3, valk=valk, si=vali(1))
!
        endif
    end do
!
    call jedema()
end subroutine
