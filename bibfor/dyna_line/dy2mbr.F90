! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine dy2mbr(numddl, neq, lischa, freq, vediri,&
                  veneum, vevoch, vassec, j2nd)
!
!
    implicit      none
#include "jeveux.h"
#include "asterfort/ascomb.h"
#include "asterfort/cnvesl.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/vtcreb.h"
#include "asterfort/vecinc.h"
    character(len=19) :: lischa
    integer :: neq, j2nd
    real(kind=8) :: freq
    character(len=14) :: numddl
    character(len=19) :: vediri, veneum, vevoch, vassec
!
! ----------------------------------------------------------------------
!
! DYNA_VIBRA//HARM/GENE
!
! CALCUL DU SECOND MEMBRE
!
! ----------------------------------------------------------------------
!
!
! IN  VEDIRI : VECT_ELEM DE L'ASSEMBLAGE DES ELEMENTS DE LAGRANGE
! IN  VENEUM : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS DE NEUMANN
! IN  VEVOCH : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS EVOL_CHAR
! IN  VASSEC : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS VECT_ASSE_CHAR
! IN  LISCHA : SD LISTE DES CHARGES
! IN  NUMDDL : NOM DU NUME_DDL
! IN  FREQ   : VALEUR DE LA FREQUENCE
! IN  NEQ    : NOMBRE D'EQUATIONS DU SYSTEME
! IN  J2ND   : ADRESSE DU VECTEUR ASSEMBLE SECOND MEMBRE
!
!
!
!
    integer :: ieq
    integer :: j2nd1, j2nd2, j2nd3, j2nd4, j2nd5
    character(len=1) :: typres
    character(len=8) :: para
    character(len=19):: cndiri, cnneum, cnvoch, cnveac, cnvass
    complex(kind=8)  :: czero
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    typres = 'C'
    para = 'FREQ'
    czero = dcmplx(0.d0,0.d0)
    cndiri = '&&DY2MBR.CNDIRI'
    cnneum = '&&DY2MBR.CNNEUM'
    cnvoch = '&&DY2MBR.CNVOCH'
    cnveac = '&&DY2MBR.CNVEAC'
    cnvass = '&&DY2MBR.CNVASS'
    call vtcreb(cndiri, 'V', typres,&
                nume_ddlz = numddl,&
                nb_equa_outz = neq)
    call vtcreb(cnneum, 'V', typres,&
                nume_ddlz = numddl,&
                nb_equa_outz = neq)
    call vtcreb(cnvoch, 'V', typres,&
                nume_ddlz = numddl,&
                nb_equa_outz = neq)
    call vtcreb(cnveac, 'V', typres,&
                nume_ddlz = numddl,&
                nb_equa_outz = neq)
    call vtcreb(cnvass, 'V', typres,&
                nume_ddlz = numddl,&
                nb_equa_outz = neq)
!
! --- VECTEUR RESULTANT
!
    call vecinc(neq, czero, zc(j2nd))
!
! --- ASSEMBLAGE DES CHARGEMENTS DE DIRICHLET
!
    call ascomb(lischa, vediri, typres, para, freq, cndiri)
!
! --- ASSEMBLAGE DES CHARGEMENTS DE NEUMANN STANDARDS
!
    call ascomb(lischa, veneum, typres, para, freq, cnneum)
!
! --- ASSEMBLAGE DU CHARGEMENT DE TYPE EVOL_CHAR
!
    call ascomb(lischa, vevoch, typres, para, freq, cnvoch)
!
! --- ASSEMBLAGE DU CHARGEMENT DE TYPE VECT_ASSE_CHAR
!
    call ascomb(lischa, vassec, typres, para, freq, cnveac)
!
! --- CHARGEMENT DE TYPE VECT_ASSE
!
    call cnvesl(lischa, typres, neq, para, freq, cnvass)
!
! --- CUMUL DES DIFFERENTS TERMES DU SECOND MEMBRE DEFINITIF
!
    call jeveuo(cndiri(1:19)//'.VALE', 'L', j2nd1)
    call jeveuo(cnneum(1:19)//'.VALE', 'L', j2nd2)
    call jeveuo(cnvoch(1:19)//'.VALE', 'L', j2nd3)
    call jeveuo(cnveac(1:19)//'.VALE', 'L', j2nd4)
    call jeveuo(cnvass(1:19)//'.VALE', 'L', j2nd5)
    do ieq = 1, neq
        zc(j2nd+ieq-1) = zc(j2nd1+ieq-1) + zc(j2nd2+ieq-1) + zc(j2nd3+ ieq-1) + zc(j2nd4+ieq-1) +&
                         & zc(j2nd5+ieq-1)
    end do
!
    call detrsd('CHAMP_GD', cndiri)
    call detrsd('CHAMP_GD', cnneum)
    call detrsd('CHAMP_GD', cnvoch)
    call detrsd('CHAMP_GD', cnveac)
    call detrsd('CHAMP_GD', cnvass)
!
    call jedema()
!
end subroutine
