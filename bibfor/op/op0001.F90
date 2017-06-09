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

subroutine op0001()
!
!-----------------------------------------------------------------------
!           operateur    LIRE_MAILLAGE
!-----------------------------------------------------------------------
!
!       COODSC          NOM DE L OBJET CHAMP DE GEOMETRIE (DESCRIPTEUR)
!       COOREF          NOM DE L OBJET CHAMP DE GEOMETRIE (NOM MAILLAGE)
!       GRPNOE          NOM DE L OBJET GROUPE NOEUDS
!       GRPMAI          NOM DE L OBJET GROUPE MAILLES
!       NOMMAI          NOM DE L OBJET REPERTOIRE DES MAILLES
!       NOMNOE          NOM DE L OBJET REPERTOIRE DES NOEUDS
!       TITRE           NOM DE L OBJET TITRE
!
!-----------------------------------------------------------------------
!
    implicit none
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/cargeo.h"
#include "asterfort/chckma.h"
#include "asterfort/getvem.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/infoma.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lrmast.h"
#include "asterfort/lrmhdf.h"
#include "asterfort/mavegr.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"

!
! ----- DECLARATIONS
!
    integer :: iaux, niv, ifl, ifm
    integer :: nbnoeu, nbmail, nbcoor
    integer :: iret, infmed
    character(len=8) :: nomu, fmt, veri
    character(len=16) :: concep,cmd
    character(len=64) :: nomamd
    real(kind=8) :: dtol
    integer, pointer :: dime(:) => null()

!---------------------------------------------------------------------------------------
    call jemarq()
!
! --- RECUPERATION DES ARGUMENTS  DE LA COMMANDE
!
    ifl = 0
    call infmaj()
    call infniv(ifm, niv)
!
    call getres(nomu, concep, cmd)
!
    call getvis(' ', 'UNITE', scal=ifl, nbret=iaux)
!
    call getvtx(' ', 'FORMAT', scal=fmt, nbret=iaux)
!
    if (fmt(1:3) .eq. 'MED') then
        call getvtx(' ', 'NOM_MED', scal=nomamd, nbret=iaux)
        if (iaux .eq. 0) then
!                   12345678901234567890123456789012
            nomamd = ' '
        endif
        call getvis(' ', 'INFO_MED', scal=infmed, nbret=iaux)
!
    endif
!
! --- LECTURE DU MAILLAGE AU FORMAT ASTER :
!     -----------------------------------
    if (fmt(1:5) .eq. 'ASTER') then
        call lrmast(nomu, ifm, ifl, nbnoeu, nbmail,&
                    nbcoor)
!
! --- LECTURE DU MAILLAGE AU FORMAT MED :
!     ---------------------------------
    else if (fmt(1:3) .eq. 'MED') then
        call lrmhdf(nomamd, nomu, ifm, ifl, niv,&
                    infmed, nbnoeu, nbmail, nbcoor)
    endif


! --- SUPPRESSION DES GROUPES DE NOEUDS OU MAILLES DE NOM ' ' :
!     -------------------------------------------------------
    call mavegr(nomu)


! --- CREATION DE L'OBJET .DIME :
!     -------------------------
    call wkvect(nomu//'.DIME', 'G V I', 6, vi=dime)
    dime(1)= nbnoeu
    dime(3)= nbmail
    dime(6)= nbcoor


! --- CARACTERISTIQUES GEOMETRIQUES :
!     -----------------------------
    call cargeo(nomu)


! --- PHASE DE VERIFICATION DU MAILLAGE :
!     ---------------------------------
    call getvtx('VERI_MAIL', 'VERIF', iocc=1, scal=veri, nbret=iret)
    if (veri .eq. 'OUI') then
        call getvr8('VERI_MAIL', 'APLAT', iocc=1, scal=dtol, nbret=iret)
        call chckma(nomu, dtol)
    else
        call utmess('A', 'MODELISA5_49')
    endif


!     IMPRESSIONS DU MOT CLE INFO :
!     ---------------------------
    call infoma(nomu)
!
    call jedema()
end subroutine
