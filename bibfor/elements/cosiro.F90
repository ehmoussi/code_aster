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

subroutine cosiro(nomte, param, loue, sens, goun,&
                  jtens, sour)
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
! BUT : CHANGER LE REPERE : INTRINSEQUE <-> UTILISATEUR
!       POUR UN CHAMP LOCAL DE CONTRAINTE (OU DE DEFORMATION)
!       (MODELISATIONS : DKT/DST/Q4G/COQUE_3D)
!
! ARGUMENTS :
!  NOMTE  IN : NOM DU TYPE_ELEMENT
!  PARAM  IN : NOM DU CHAMP LOCAL A MODIFIER
!  LOUE   IN :  / 'L' : PARAMETRE EN LECTURE
!               / 'E' : PARAMETRE EN ECRITURE
!  SENS   IN :  / 'IU' : INTRINSEQUE -> UTILISATEUR
!               / 'UI' : UTILISATEUR -> INTRINSEQUE
!  GOUN   IN :  / 'G' : CHAMP ELGA
!               / 'N' : CHAMP ELNO
!  JTENS  OUT : ADRESSE DU CHAMP LOCAL (QUE L'ON A MODIFIE)
!  SOUR   IN :  / 'S' : ON CALCULE LE CHANGEMENT DE REPERE
!                       ET ON LE CONSERVE (SAVE)
!               / 'R' : ON REUTILISE LE CHANGEMENT DE REPERE
!                       CALCULE (ET SAUVE) PRECEDEMMENT
!  REMARQUE : UTILISER SOUR='R' PEUT FAIRE GAGNER UN PEU DE TEMPS MAIS
!             CELA PERMET SURTOUT DE SE PROTEGER DES TE00IJ QUI
!             MODIFIENT LA GEOMETRIE INITIALE (EX : TE0031)
! ======================================================================
    implicit none
!
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/assert.h"
#include "asterfort/coqrep.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxsiro.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/vdrepe.h"
#include "asterfort/vdsiro.h"
#include "asterfort/vdxrep.h"
#include "asterfort/lteatt.h"
    character(len=*) :: param
    character(len=16) :: nomte
    character(len=2) :: sens
    character(len=1) :: loue, goun, sour
    integer :: jtens, npgt, jgeom, jcara
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfdx, jgano
    integer :: itab(7), iret, nbpt, nbsp
    parameter      (npgt=10)
    real(kind=8) :: matevn(2, 2, npgt), matevg(2, 2, npgt)
    real(kind=8) :: t2iu(4), t2ui(4), pgl(3, 3), epais, alpha, beta
    real(kind=8) :: c, s
    save           t2iu,t2ui,matevn,matevg
!
    ASSERT(loue.eq.'L' .or. loue.eq.'E')
    ASSERT(sens.eq.'UI' .or. sens.eq.'IU')
    ASSERT(sour.eq.'S' .or. sour.eq.'R')
    ASSERT(goun.eq.'G' .or. goun.eq.'N')
!
!     -- ADRESSE DU CHAMP LOCAL A MODIFIER + NBPT + NBSP
    call tecach('NOO', param, loue, iret, nval=7,&
                itab=itab)
    ASSERT(iret.eq.0 .or. iret.eq.1)
!
!     -- SI IRET=1 : IL N'Y A RIEN A FAIRE :
    if (iret .eq. 1) then
        goto 10
    endif
!
    jtens = itab(1)
    nbpt = itab(3)
    nbsp = itab(7)
!
!     -- CAS DES ELEMENTS DE COQUE_3D :
!     -----------------------------------
    if (lteatt('MODELI','CQ3')) then
!
        if (sour .eq. 'S') then
            call jevech('PCACOQU', 'L', jcara)
            epais = zr(jcara)
!         -- REMPLISSAGE DE DESR : 1090 ET 2000 :
            call jevech('PGEOMER', 'L', jgeom)
            call vdxrep(nomte, epais, zr(jgeom))
!
!         -- CALCUL DES MATRICES DE CHANGEMENT DE REPERE :
            call vdrepe(nomte, matevn, matevg)
        endif
!
!       -- MODIFICATION DU CHAMP LOCAL

        if (goun .eq. 'G') then
            call vdsiro(nbpt, nbsp, matevg, sens, goun,&
                        zr(jtens), zr(jtens))
        else
            call vdsiro(nbpt, nbsp, matevn, sens, goun,&
                        zr(jtens), zr(jtens))
        endif
!
    else
!     -- CAS DES ELEMENTS DKT, DST, Q4G  :
!     ------------------------------------
        call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfdx,jgano=jgano)
!
        if (sour .eq. 'S') then
            call jevech('PGEOMER', 'L', jgeom)
            if (nno .eq. 3) then
                call dxtpgl(zr(jgeom), pgl)
            else if (nno.eq.4) then
                call dxqpgl(zr(jgeom), pgl, 'S', iret)
            endif
            call jevech('PCACOQU', 'L', jcara)
            alpha = zr(jcara+1) * r8dgrd()
            beta = zr(jcara+2) * r8dgrd()
            call coqrep(pgl, alpha, beta, t2iu, t2ui,&
                        c, s)
        endif
!
        if (sens .eq. 'UI') then
            call dxsiro(nbpt*nbsp, t2ui, zr(jtens), zr(jtens))
        else
            call dxsiro(nbpt*nbsp, t2iu, zr(jtens), zr(jtens))
        endif
    endif
!
10  continue
end subroutine
